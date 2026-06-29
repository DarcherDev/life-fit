import 'package:life_fit/core/services/local_storage_service.dart';

enum TodayGymEntry {
  ready,
  pickRoutine,
  createRoutine,
}

TodayGymEntry resolveTodayGymEntry(
  LocalStorageService storage,
  String dateKey,
) {
  if (storage.getAssignmentForDate(dateKey) != null) {
    return TodayGymEntry.ready;
  }
  if (storage.getRoutineCards().isEmpty) {
    return TodayGymEntry.createRoutine;
  }
  return TodayGymEntry.pickRoutine;
}
