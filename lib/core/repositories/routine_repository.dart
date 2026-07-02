import 'package:life_fit/shared/models/routine_card.dart';

abstract class RoutineRepository {
  List<RoutineCard> getRoutineCards();

  RoutineCard? getRoutineById(String routineId);

  Future<void> upsertRoutineCard(RoutineCard card);

  Future<void> deleteRoutineCard(String routineId);
}
