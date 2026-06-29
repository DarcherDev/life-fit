import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'library_migration_v1_done': true});
    await LocalStorageService.init();
  });

  test('LocalStorageService guarda rutinas con slots y asignaciones', () async {
    final storage = LocalStorageService.instance;

    await storage.upsertExerciseTemplate(
      const ExerciseTemplate(
        id: 'ex-1',
        title: 'Press',
        series: 4,
        repetitions: 10,
      ),
    );

    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR 1',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
    );

    await storage.upsertRoutineCard(card);
    await storage.saveAssignment('2026-06-27', card.id);

    expect(storage.getRoutineCards().length, 1);
    expect(storage.getAssignmentForDate('2026-06-27')?.routineId, card.id);
  });

  test('LocalStorageService guarda progreso por slotId', () async {
    final storage = LocalStorageService.instance;

    await storage.toggleItem('2026-06-27', 'slot-1', true);

    final progress = storage.getDayProgress('2026-06-27');
    expect(progress.completedItemIds, {'slot-1'});
  });
}
