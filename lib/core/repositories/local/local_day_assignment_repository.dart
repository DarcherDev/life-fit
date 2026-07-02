import 'package:life_fit/core/repositories/day_assignment_repository.dart';
import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/shared/models/day_assignment.dart';

class LocalDayAssignmentRepository implements DayAssignmentRepository {
  LocalDayAssignmentRepository(this._store);

  static const _key = 'day_assignments';

  final SharedPrefsJsonStore _store;

  @override
  List<DayAssignment> getAssignments() {
    return _store.readList(_key, DayAssignment.fromJson);
  }

  @override
  DayAssignment? getAssignmentForDate(String dateKey) {
    for (final assignment in getAssignments()) {
      if (assignment.dateKey == dateKey) {
        return assignment;
      }
    }
    return null;
  }

  @override
  Future<void> saveAssignment(String dateKey, String? routineId) async {
    final assignments = getAssignments()
      ..removeWhere((assignment) => assignment.dateKey == dateKey);

    if (routineId != null) {
      assignments.add(DayAssignment(dateKey: dateKey, routineId: routineId));
    }

    await _store.writeList(_key, assignments, (item) => item.toJson());
  }

  @override
  Future<void> removeAssignmentsForRoutine(String routineId) async {
    final assignments = getAssignments()
      ..removeWhere((assignment) => assignment.routineId == routineId);
    await _store.writeList(_key, assignments, (item) => item.toJson());
  }
}
