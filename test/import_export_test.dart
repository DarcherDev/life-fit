import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/data/default_library_catalog.dart';
import 'package:life_fit/core/import_export/life_fit_export_document.dart';
import 'package:life_fit/core/import_export/routine_export_service.dart';
import 'package:life_fit/core/import_export/routine_import_service.dart';
import 'package:life_fit/core/import_export/sample_routine_document_builder.dart';
import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppRepositories> initRepos() async {
    SharedPreferences.setMockInitialValues({
      'library_migration_v1_done': true,
      'default_library_seed_v1_done': true,
    });
    return AppRepositories.init();
  }

  test('export incluye perfil y rutinas denormalizadas', () async {
    final repos = await initRepos();

    await repos.exerciseTemplates.upsertExerciseTemplate(
      const ExerciseTemplate(
        id: 'ex-1',
        title: 'Press',
        series: 4,
        repetitions: 10,
        weightKg: 60,
      ),
    );
    await repos.stretchingTemplates.upsertStretchingTemplate(
      const StretchingTemplate(
        id: 'st-1',
        description: 'Hombro',
        repetitions: 8,
      ),
    );
    await repos.warmUpTemplates.upsertWarmUpTemplate(
      const WarmUpTemplate(
        id: 'wu-1',
        description: 'Cinta',
        minutes: 5,
      ),
    );
    await repos.routines.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-1',
        title: 'Pecho',
        description: 'Tren superior',
        exerciseSlots: [
          RoutineExerciseSlot(slotId: 'slot-e', exerciseId: 'ex-1'),
        ],
        stretchingSlots: [
          RoutineStretchingSlot(slotId: 'slot-s', stretchingId: 'st-1'),
        ],
        warmUpId: 'wu-1',
        warmUpPlacement: WarmUpPlacement.start,
      ),
    );

    final document = RoutineExportService(
      repositories: repos,
      profileReader: () => const PersonalProfile(
        ageYears: 30,
        heightCm: 175,
        bodyWeightKg: 80,
      ),
      weightUnitReader: () => WeightUnit.lb,
      clock: () => DateTime.utc(2026, 8, 7, 12),
    ).buildDocument();

    expect(document.schemaVersion, 1);
    expect(document.profile.ageYears, 30);
    expect(document.profile.weightUnit, WeightUnit.lb);
    expect(document.routines, hasLength(1));
    expect(document.routines.first.title, 'Pecho');
    expect(document.routines.first.exercises.first.title, 'Press');
    expect(document.routines.first.exercises.first.weightKg, 60);
    expect(document.routines.first.stretchings.first.description, 'Hombro');
    expect(document.routines.first.warmUp!.minutes, 5);

    final encoded = jsonDecode(jsonEncode(document.toJson()));
    final roundTrip =
        LifeFitExportDocument.fromJson(encoded as Map<String, dynamic>);
    expect(roundTrip.routines.first.exercises.first.id, 'ex-1');
  });

  test('import reemplaza rutinas, hace upsert y conserva plantillas no usadas',
      () async {
    final repos = await initRepos();

    await repos.exerciseTemplates.upsertExerciseTemplate(
      const ExerciseTemplate(
        id: 'ex-old',
        title: 'Viejo',
        series: 3,
        repetitions: 8,
      ),
    );
    await repos.exerciseTemplates.upsertExerciseTemplate(
      const ExerciseTemplate(
        id: 'ex-keep',
        title: 'Conservar',
        series: 2,
        repetitions: 12,
      ),
    );
    await repos.routines.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-old',
        title: 'Antigua',
        description: '',
        exerciseSlots: [
          RoutineExerciseSlot(slotId: 's1', exerciseId: 'ex-old'),
        ],
      ),
    );
    await repos.assignments.saveAssignment('2026-08-01', 'routine-old');
    await repos.progress.toggleItem('2026-08-01', 's1', true);

    var savedProfile = PersonalProfile.empty;
    WeightUnit? savedUnit;

    final json = jsonEncode({
      'schemaVersion': 1,
      'exportedAt': '2026-08-07T12:00:00.000Z',
      'profile': {
        'ageYears': 28,
        'heightCm': 170,
        'bodyWeightKg': 75,
        'weightUnit': 'kg',
      },
      'routines': [
        {
          'id': 'routine-new',
          'title': 'Nueva',
          'exercises': [
            {
              'id': 'ex-old',
              'title': 'Actualizado',
              'series': 5,
              'repetitions': 5,
              'weightKg': 40,
            },
            {
              'title': 'Sin id',
              'series': 3,
              'repetitions': 10,
            },
          ],
        },
      ],
    });

    await RoutineImportService(
      repositories: repos,
      profileReader: () => const PersonalProfile(ageYears: 40),
      saveProfile: (profile) async {
        savedProfile = profile;
      },
      saveWeightUnit: (unit) async {
        savedUnit = unit;
      },
    ).importJsonString(json);

    final routines = repos.routines.getRoutineCards();
    expect(routines, hasLength(1));
    expect(routines.first.id, 'routine-new');
    expect(routines.first.title, 'Nueva');
    expect(routines.first.exerciseSlots, hasLength(2));

    final exercises = repos.exerciseTemplates.getExerciseTemplates();
    expect(exercises.any((item) => item.id == 'ex-keep'), isTrue);
    final updated = exercises.firstWhere((item) => item.id == 'ex-old');
    expect(updated.title, 'Actualizado');
    expect(updated.series, 5);
    expect(exercises.where((item) => item.title == 'Sin id'), hasLength(1));

    expect(repos.assignments.getAssignmentForDate('2026-08-01'), isNull);
    expect(
      repos.progress.getDayProgress('2026-08-01').completedItemIds,
      isEmpty,
    );

    expect(savedProfile.ageYears, 28);
    expect(savedProfile.heightCm, 170);
    expect(savedUnit, WeightUnit.kg);
  });

  test('import rechaza schema no soportado sin mutar rutinas', () async {
    final repos = await initRepos();
    await repos.routines.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-1',
        title: 'Keep',
        description: '',
      ),
    );

    expect(
      () => RoutineImportService(
        repositories: repos,
        profileReader: () => PersonalProfile.empty,
        saveProfile: (_) async {},
        saveWeightUnit: (_) async {},
      ).importJsonString(
        jsonEncode({
          'schemaVersion': 99,
          'routines': [],
        }),
      ),
      throwsA(
        isA<RoutineImportException>().having(
          (error) => error.message,
          'message',
          'unsupported_schema',
        ),
      ),
    );

    expect(repos.routines.getRoutineCards().single.title, 'Keep');
  });

  test('import rechaza JSON inválido', () async {
    final repos = await initRepos();

    expect(
      () => RoutineImportService(
        repositories: repos,
        profileReader: () => PersonalProfile.empty,
        saveProfile: (_) async {},
        saveWeightUnit: (_) async {},
      ).importJsonString('no-es-json'),
      throwsA(
        isA<RoutineImportException>().having(
          (error) => error.message,
          'message',
          'invalid_json',
        ),
      ),
    );
  });

  test('import aplica títulos y series/reps por defecto', () async {
    final repos = await initRepos();

    await RoutineImportService(
      repositories: repos,
      profileReader: () => PersonalProfile.empty,
      saveProfile: (_) async {},
      saveWeightUnit: (_) async {},
    ).importJsonString(jsonEncode({
      'schemaVersion': 1,
      'routines': [
        {
          'title': '',
          'warmUp': {'description': 'Movilidad'},
          'stretchings': [
            {'description': 'Cuello'},
          ],
          'exercises': [
            {'title': ''},
            {'title': '  '},
            {
              'title': 'Press',
              'series': 4,
              'repetitions': 8,
            },
          ],
        },
        {
          'exercises': [
            {'title': ''},
          ],
        },
      ],
    }));

    final routines = repos.routines.getRoutineCards();
    expect(routines[0].title, 'Rutina 1');
    expect(routines[1].title, 'Rutina 2');

    final libraries = repos.getLibraries();
    final firstRoutine = routines[0];
    final ex1 =
        libraries.exercises[firstRoutine.exerciseSlots[0].exerciseId]!;
    final ex2 =
        libraries.exercises[firstRoutine.exerciseSlots[1].exerciseId]!;
    final ex3 =
        libraries.exercises[firstRoutine.exerciseSlots[2].exerciseId]!;

    expect(ex1.title, 'Ejercicio 1');
    expect(ex1.series, 3);
    expect(ex1.repetitions, 10);
    expect(ex1.weightKg, isNull);
    expect(ex2.title, 'Ejercicio 2');
    expect(ex3.title, 'Press');
    expect(ex3.series, 4);
    expect(ex3.repetitions, 8);

    final warmUp = libraries.warmUps[firstRoutine.warmUpId!]!;
    expect(warmUp.minutes, 10);

    final stretching =
        libraries.stretchings[firstRoutine.stretchingSlots.first.stretchingId]!;
    expect(stretching.repetitions, 10);

    final secondEx =
        libraries.exercises[routines[1].exerciseSlots.first.exerciseId]!;
    expect(secondEx.title, 'Ejercicio 1');
  });

  SampleRoutineDocumentBuilder sampleBuilder() {
    return SampleRoutineDocumentBuilder(
      profileReader: () => const PersonalProfile(
        ageYears: 26,
        heightCm: 163,
        bodyWeightKg: 71,
      ),
      weightUnitReader: () => WeightUnit.kg,
      routineTitle: 'Rutina de ejemplo',
      routineDescription: 'Adapta esta rutina con IA',
      clock: () => DateTime.utc(2026, 9, 30, 12),
    );
  }

  test('documento de ejemplo usa perfil y biblioteca base', () {
    final document = sampleBuilder().buildDocument();

    expect(document.schemaVersion, 1);
    expect(document.profile.ageYears, 26);
    expect(document.profile.heightCm, 163);
    expect(document.profile.weightUnit, WeightUnit.kg);
    expect(document.routines, hasLength(1));

    final routine = document.routines.single;
    expect(routine.title, 'Rutina de ejemplo');
    expect(routine.warmUp!.id, DefaultLibraryCatalog.warmUpTemplates.first.id);
    expect(routine.stretchings, hasLength(2));
    expect(routine.exercises, hasLength(4));
    expect(
      routine.exercises.map((item) => item.id),
      DefaultLibraryCatalog.exerciseTemplates.take(4).map((item) => item.id),
    );
  });

  test('importar el ejemplo no duplica la biblioteca base', () async {
    SharedPreferences.setMockInitialValues({
      'library_migration_v1_done': true,
    });
    final repos = await AppRepositories.init();
    final exercisesBefore =
        repos.exerciseTemplates.getExerciseTemplates().length;
    final stretchingsBefore =
        repos.stretchingTemplates.getStretchingTemplates().length;
    final warmUpsBefore = repos.warmUpTemplates.getWarmUpTemplates().length;

    await RoutineImportService(
      repositories: repos,
      profileReader: () => PersonalProfile.empty,
      saveProfile: (_) async {},
      saveWeightUnit: (_) async {},
    ).importJsonString(sampleBuilder().buildJsonString());

    final routines = repos.routines.getRoutineCards();
    expect(routines, hasLength(1));
    expect(routines.single.title, 'Rutina de ejemplo');
    expect(
      repos.exerciseTemplates.getExerciseTemplates(),
      hasLength(exercisesBefore),
    );
    expect(
      repos.stretchingTemplates.getStretchingTemplates(),
      hasLength(stretchingsBefore),
    );
    expect(repos.warmUpTemplates.getWarmUpTemplates(), hasLength(warmUpsBefore));
  });

  test('hasRoutines refleja si hay rutinas guardadas', () async {
    final repos = await initRepos();
    final service = RoutineExportService(
      repositories: repos,
      profileReader: () => PersonalProfile.empty,
      weightUnitReader: () => WeightUnit.kg,
    );

    expect(service.hasRoutines, isFalse);

    await repos.routines.upsertRoutineCard(
      const RoutineCard(id: 'routine-1', title: 'Pecho', description: ''),
    );

    expect(service.hasRoutines, isTrue);
  });
}
