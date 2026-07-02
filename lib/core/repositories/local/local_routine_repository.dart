import 'package:life_fit/core/repositories/day_assignment_repository.dart';
import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';
import 'package:life_fit/shared/models/routine_card.dart';

class LocalRoutineRepository implements RoutineRepository {
  LocalRoutineRepository(this._store, this._assignments);

  static const _key = 'routine_cards';

  final SharedPrefsJsonStore _store;
  final DayAssignmentRepository _assignments;

  @override
  List<RoutineCard> getRoutineCards() {
    return _store.readList(_key, RoutineCard.fromJson);
  }

  @override
  RoutineCard? getRoutineById(String routineId) {
    for (final card in getRoutineCards()) {
      if (card.id == routineId) {
        return card;
      }
    }
    return null;
  }

  @override
  Future<void> upsertRoutineCard(RoutineCard card) async {
    final cards = getRoutineCards();
    final index = cards.indexWhere((existing) => existing.id == card.id);

    if (index >= 0) {
      cards[index] = card;
    } else {
      cards.add(card);
    }

    await _store.writeList(_key, cards, (item) => item.toJson());
  }

  @override
  Future<void> deleteRoutineCard(String routineId) async {
    final cards = getRoutineCards()..removeWhere((card) => card.id == routineId);
    await _store.writeList(_key, cards, (item) => item.toJson());
    await _assignments.removeAssignmentsForRoutine(routineId);
  }
}
