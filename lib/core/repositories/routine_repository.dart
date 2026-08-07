import 'package:life_fit/shared/models/routine_card.dart';

abstract class RoutineRepository {
  List<RoutineCard> getRoutineCards();

  RoutineCard? getRoutineById(String routineId);

  Future<void> upsertRoutineCard(RoutineCard card);

  Future<void> deleteRoutineCard(String routineId);

  /// Sustituye por completo la lista de rutinas (sin tocar asignaciones).
  Future<void> replaceAllRoutineCards(List<RoutineCard> cards);
}
