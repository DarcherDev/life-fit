import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'library_migration_v1_done': true});
    await AppRepositories.init();
  });

  test('AppRepositories guarda rutinas con slots y asignaciones', () async {
    final repos = AppRepositories.instance;

    await repos.exerciseTemplates.upsertExerciseTemplate(
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

    await repos.routines.upsertRoutineCard(card);
    await repos.assignments.saveAssignment('2026-06-27', card.id);

    expect(repos.routines.getRoutineCards().length, 1);
    expect(
      repos.assignments.getAssignmentForDate('2026-06-27')?.routineId,
      card.id,
    );
  });

  test('AppRepositories guarda progreso por slotId', () async {
    final repos = AppRepositories.instance;

    await repos.progress.toggleItem('2026-06-27', 'slot-1', true);

    final progress = repos.progress.getDayProgress('2026-06-27');
    expect(progress.completedItemIds, {'slot-1'});
  });
}
