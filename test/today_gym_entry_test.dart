import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/modules/dia_gym/flows/today_gym_entry.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'library_migration_v1_done': true,
      'default_library_seed_v1_done': true,
    });
    await AppRepositories.init();
  });

  test('sin asignación ni rutinas devuelve createRoutine', () {
    final repos = AppRepositories.instance;

    expect(
      resolveTodayGymEntry(
        repos.assignments,
        repos.routines,
        '2026-06-27',
      ),
      TodayGymEntry.createRoutine,
    );
  });

  test('sin asignación con rutinas devuelve pickRoutine', () async {
    final repos = AppRepositories.instance;

    await repos.routines.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-1',
        title: 'MIÉRCOLES',
        description: 'TREN SUPERIOR',
        exerciseSlots: [
          RoutineExerciseSlot(
            slotId: 'item-1',
            exerciseId: 'exercise-1',
          ),
        ],
      ),
    );

    expect(
      resolveTodayGymEntry(
        repos.assignments,
        repos.routines,
        '2026-06-27',
      ),
      TodayGymEntry.pickRoutine,
    );
  });

  test('con asignación devuelve ready', () async {
    final repos = AppRepositories.instance;

    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR',
      exerciseSlots: [
        RoutineExerciseSlot(
          slotId: 'item-1',
          exerciseId: 'exercise-1',
        ),
      ],
    );

    await repos.routines.upsertRoutineCard(card);
    await repos.assignments.saveAssignment('2026-06-27', card.id);

    expect(
      resolveTodayGymEntry(
        repos.assignments,
        repos.routines,
        '2026-06-27',
      ),
      TodayGymEntry.ready,
    );
  });
}
