import 'package:life_fit/core/repositories/day_progress_repository.dart';
import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/shared/models/day_progress.dart';

class LocalDayProgressRepository implements DayProgressRepository {
  LocalDayProgressRepository(this._store);

  static const _key = 'day_progress';

  final SharedPrefsJsonStore _store;

  @override
  DayProgress getDayProgress(String dateKey) {
    final allProgress = _getAllProgress();
    return allProgress.firstWhere(
      (progress) => progress.dateKey == dateKey,
      orElse: () => DayProgress(dateKey: dateKey, completedItemIds: {}),
    );
  }

  @override
  Future<void> toggleItem(String dateKey, String itemId, bool completed) async {
    final allProgress = _getAllProgress();
    final index =
        allProgress.indexWhere((progress) => progress.dateKey == dateKey);

    DayProgress progress;
    if (index >= 0) {
      progress = allProgress[index];
    } else {
      progress = DayProgress(dateKey: dateKey, completedItemIds: {});
    }

    final updatedIds = Set<String>.from(progress.completedItemIds);
    if (completed) {
      updatedIds.add(itemId);
    } else {
      updatedIds.remove(itemId);
    }

    final updatedProgress = progress.copyWith(completedItemIds: updatedIds);

    if (index >= 0) {
      allProgress[index] = updatedProgress;
    } else {
      allProgress.add(updatedProgress);
    }

    await _store.writeList(_key, allProgress, (item) => item.toJson());
  }

  List<DayProgress> _getAllProgress() {
    return _store.readList(_key, DayProgress.fromJson);
  }
}
