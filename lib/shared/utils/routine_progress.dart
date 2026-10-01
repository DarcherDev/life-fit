import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/shared/models/routine_card.dart';

class RoutineProgressSummary {
  const RoutineProgressSummary({
    required this.hasRoutine,
    required this.totalItems,
    required this.completedItems,
  });

  final bool hasRoutine;
  final int totalItems;
  final int completedItems;

  double get fraction {
    if (totalItems == 0) {
      return 0;
    }
    return completedItems / totalItems;
  }

  int get percent => (fraction * 100).round();

  bool get isComplete => hasRoutine && totalItems > 0 && completedItems >= totalItems;
}

List<String> collectRoutineProgressItemIds(RoutineCard routine) {
  final ids = <String>[];
  if (routine.startWarmUpId != null) {
    ids.add(warmUpProgressItemIdFor(WarmUpPlacement.start));
  }
  for (final slot in routine.stretchingSlots) {
    ids.add(slot.slotId);
  }
  for (final slot in routine.exerciseSlots) {
    ids.add(slot.slotId);
  }
  if (routine.endWarmUpId != null) {
    ids.add(warmUpProgressItemIdFor(WarmUpPlacement.end));
  }
  return ids;
}

RoutineProgressSummary calculateRoutineProgress({
  RoutineCard? routine,
  required Set<String> completedItemIds,
}) {
  if (routine == null) {
    return const RoutineProgressSummary(
      hasRoutine: false,
      totalItems: 0,
      completedItems: 0,
    );
  }

  final itemIds = collectRoutineProgressItemIds(routine);
  if (itemIds.isEmpty) {
    return const RoutineProgressSummary(
      hasRoutine: true,
      totalItems: 0,
      completedItems: 0,
    );
  }

  final completedCount =
      itemIds.where(completedItemIds.contains).length;

  return RoutineProgressSummary(
    hasRoutine: true,
    totalItems: itemIds.length,
    completedItems: completedCount,
  );
}
