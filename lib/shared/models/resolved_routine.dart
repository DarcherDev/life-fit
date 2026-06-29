import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

class ResolvedWarmUp {
  const ResolvedWarmUp({
    required this.description,
    required this.minutes,
    this.isMissing = false,
  });

  final String description;
  final int minutes;
  final bool isMissing;
}

class ResolvedExercise {
  const ResolvedExercise({
    required this.slotId,
    required this.title,
    required this.series,
    required this.repetitions,
    this.description = '',
    this.isMissing = false,
  });

  final String slotId;
  final String title;
  final int series;
  final int repetitions;
  final String description;
  final bool isMissing;
}

class ResolvedStretching {
  const ResolvedStretching({
    required this.slotId,
    required this.description,
    required this.repetitions,
    this.isMissing = false,
  });

  final String slotId;
  final String description;
  final int repetitions;
  final bool isMissing;
}

class ResolvedRoutine {
  const ResolvedRoutine({
    required this.id,
    required this.title,
    required this.description,
    this.warmUp,
    this.warmUpPlacement = WarmUpPlacement.start,
    this.stretchingItems = const [],
    this.exercises = const [],
  });

  final String id;
  final String title;
  final String description;
  final ResolvedWarmUp? warmUp;
  final WarmUpPlacement warmUpPlacement;
  final List<ResolvedStretching> stretchingItems;
  final List<ResolvedExercise> exercises;

  bool get hasWarmUp => warmUp != null;
  bool get hasStretching => stretchingItems.isNotEmpty;
  bool get hasExercises => exercises.isNotEmpty;
  bool get hasMissingItems =>
      (warmUp?.isMissing ?? false) ||
      stretchingItems.any((item) => item.isMissing) ||
      exercises.any((item) => item.isMissing);
}
