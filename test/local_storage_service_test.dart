import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/core/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  test('RoutineCard serializa y deserializa correctamente', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR 1',
      items: [
        ChecklistItem(
          id: 'item-1',
          title: 'Press de Banca Plana',
          series: 4,
          repetitions: 10,
        ),
      ],
    );

    final decoded = RoutineCard.fromJson(card.toJson());

    expect(decoded.id, card.id);
    expect(decoded.title, card.title);
    expect(decoded.description, card.description);
    expect(decoded.items.length, 1);
    expect(decoded.items.first.series, 4);
    expect(decoded.items.first.repetitions, 10);
  });

  test('LocalStorageService guarda rutinas y asignaciones', () async {
    final storage = LocalStorageService.instance;

    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR 1',
      items: [
        ChecklistItem(
          id: 'item-1',
          title: 'Press de Banca Plana',
          series: 4,
          repetitions: 10,
        ),
      ],
    );

    await storage.upsertRoutineCard(card);
    await storage.saveAssignment('2026-06-27', card.id);

    expect(storage.getRoutineCards().length, 1);
    expect(storage.getAssignmentForDate('2026-06-27')?.routineId, card.id);
  });

  test('LocalStorageService guarda progreso por día', () async {
    final storage = LocalStorageService.instance;

    await storage.toggleItem('2026-06-27', 'item-1', true);

    final progress = storage.getDayProgress('2026-06-27');
    expect(progress.completedItemIds, {'item-1'});

    await storage.toggleItem('2026-06-27', 'item-1', false);
    expect(storage.getDayProgress('2026-06-27').completedItemIds, isEmpty);
  });
}
