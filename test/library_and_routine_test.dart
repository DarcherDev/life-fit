import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/core/services/storage_migration.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('RoutineCard con slots serializa correctamente', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
      warmUpId: 'warm-1',
      warmUpPlacement: WarmUpPlacement.start,
    );

    final decoded = RoutineCard.fromJson(card.toJson());
    expect(decoded.exerciseSlots.first.exerciseId, 'ex-1');
    expect(decoded.warmUpId, 'warm-1');
  });

  test('resolveRoutine une bibliotecas por referencia', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: '',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
    );

    final libraries = RoutineLibraries.fromLists(
      exercises: const [
        ExerciseTemplate(
          id: 'ex-1',
          title: 'Press',
          series: 4,
          repetitions: 10,
        ),
      ],
      stretchings: const [],
      warmUps: const [],
    );

    final resolved = resolveRoutine(card, libraries);
    expect(resolved.exercises.first.title, 'Press');
    expect(resolved.exercises.first.series, 4);
    expect(resolved.exercises.first.exerciseId, 'ex-1');
  });

  test('ExerciseTemplate serializa peso opcional', () {
    const template = ExerciseTemplate(
      id: 'ex-1',
      title: 'Press',
      series: 4,
      repetitions: 10,
      weightKg: 60,
    );

    final decoded = ExerciseTemplate.fromJson(template.toJson());
    expect(decoded.weightKg, 60);
  });

  test('resolveRoutine propaga peso desde biblioteca', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: '',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
    );

    final libraries = RoutineLibraries.fromLists(
      exercises: const [
        ExerciseTemplate(
          id: 'ex-1',
          title: 'Press',
          series: 4,
          repetitions: 10,
          weightKg: 60,
        ),
      ],
      stretchings: const [],
      warmUps: const [],
    );

    final resolved = resolveRoutine(card, libraries);
    expect(resolved.exercises.first.weightKg, 60);
  });

  test('migración convierte rutina embebida a referencias', () async {
    SharedPreferences.setMockInitialValues({
      'routine_cards': jsonEncode([
        {
          'id': 'routine-1',
          'title': 'MIÉRCOLES',
          'description': 'TREN',
          'items': [
            {
              'id': 'slot-1',
              'title': 'Press',
              'series': 4,
              'repetitions': 10,
            },
          ],
        },
      ]),
    });

    await StorageMigration.runIfNeeded(
      await SharedPreferences.getInstance(),
    );
    await LocalStorageService.init();

    final storage = LocalStorageService.instance;
    final routines = storage.getRoutineCards();
    final exercises = storage.getExerciseTemplates();

    expect(routines.length, 1);
    expect(routines.first.exerciseSlots.length, 1);
    expect(routines.first.exerciseSlots.first.slotId, 'slot-1');
    expect(exercises.length, 1);
    expect(exercises.first.title, 'Press');
  });

  test('no elimina plantilla de ejercicio si está en uso', () async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
    final storage = LocalStorageService.instance;

    const exercise = ExerciseTemplate(
      id: 'ex-1',
      title: 'Press',
      series: 4,
      repetitions: 10,
    );
    await storage.upsertExerciseTemplate(exercise);
    await storage.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-1',
        title: 'MIÉRCOLES',
        description: '',
        exerciseSlots: [
          RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
        ],
      ),
    );

    final deleted = await storage.deleteExerciseTemplate('ex-1');
    expect(deleted, isFalse);
    expect(storage.getExerciseTemplates().length, 1);
  });
}
