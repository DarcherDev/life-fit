import 'package:life_fit/shared/models/day_progress.dart';

abstract class DayProgressRepository {
  DayProgress getDayProgress(String dateKey);

  Future<void> toggleItem(String dateKey, String itemId, bool completed);
}
