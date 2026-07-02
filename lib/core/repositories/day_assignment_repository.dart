import 'package:life_fit/shared/models/day_assignment.dart';

abstract class DayAssignmentRepository {
  List<DayAssignment> getAssignments();

  DayAssignment? getAssignmentForDate(String dateKey);

  Future<void> saveAssignment(String dateKey, String? routineId);

  Future<void> removeAssignmentsForRoutine(String routineId);
}
