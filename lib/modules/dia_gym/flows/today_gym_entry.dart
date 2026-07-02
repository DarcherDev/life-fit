import 'package:life_fit/core/repositories/day_assignment_repository.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';

enum TodayGymEntry {
  ready,
  pickRoutine,
  createRoutine,
}

TodayGymEntry resolveTodayGymEntry(
  DayAssignmentRepository assignments,
  RoutineRepository routines,
  String dateKey,
) {
  if (assignments.getAssignmentForDate(dateKey) != null) {
    return TodayGymEntry.ready;
  }
  if (routines.getRoutineCards().isEmpty) {
    return TodayGymEntry.createRoutine;
  }
  return TodayGymEntry.pickRoutine;
}
