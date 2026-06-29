import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/modules/dia_gym/flows/today_gym_entry.dart';
import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/core/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  test('sin asignación ni rutinas devuelve createRoutine', () {
    final storage = LocalStorageService.instance;

    expect(
      resolveTodayGymEntry(storage, '2026-06-27'),
      TodayGymEntry.createRoutine,
    );
  });

  test('sin asignación con rutinas devuelve pickRoutine', () async {
    final storage = LocalStorageService.instance;

    await storage.upsertRoutineCard(
      const RoutineCard(
        id: 'routine-1',
        title: 'MIÉRCOLES',
        description: 'TREN SUPERIOR',
        items: [
          ChecklistItem(
            id: 'item-1',
            title: 'Press',
            series: 4,
            repetitions: 10,
          ),
        ],
      ),
    );

    expect(
      resolveTodayGymEntry(storage, '2026-06-27'),
      TodayGymEntry.pickRoutine,
    );
  });

  test('con asignación devuelve ready', () async {
    final storage = LocalStorageService.instance;

    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR',
      items: [
        ChecklistItem(
          id: 'item-1',
          title: 'Press',
          series: 4,
          repetitions: 10,
        ),
      ],
    );

    await storage.upsertRoutineCard(card);
    await storage.saveAssignment('2026-06-27', card.id);

    expect(
      resolveTodayGymEntry(storage, '2026-06-27'),
      TodayGymEntry.ready,
    );
  });
}
