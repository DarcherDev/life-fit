import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/models/resolved_routine.dart';
import 'package:life_fit/shared/models/routine_card.dart';

class RoutineLibraries {
  const RoutineLibraries({
    required this.exercises,
    required this.stretchings,
    required this.warmUps,
  });

  final Map<String, ExerciseTemplate> exercises;
  final Map<String, StretchingTemplate> stretchings;
  final Map<String, WarmUpTemplate> warmUps;

  factory RoutineLibraries.fromLists({
    required List<ExerciseTemplate> exercises,
    required List<StretchingTemplate> stretchings,
    required List<WarmUpTemplate> warmUps,
  }) {
    return RoutineLibraries(
      exercises: {for (final item in exercises) item.id: item},
      stretchings: {for (final item in stretchings) item.id: item},
      warmUps: {for (final item in warmUps) item.id: item},
    );
  }
}

ResolvedRoutine resolveRoutine(
  RoutineCard card,
  RoutineLibraries libraries, {
  AppLocalizations? l10n,
}) {
  final missingLabel = l10n?.missingTemplateLabel ?? 'No disponible';

  ResolvedWarmUp? warmUp;
  if (card.warmUpId != null) {
    final template = libraries.warmUps[card.warmUpId];
    if (template == null) {
      warmUp = ResolvedWarmUp(
        description: missingLabel,
        minutes: 0,
        isMissing: true,
      );
    } else {
      warmUp = ResolvedWarmUp(
        description: template.description,
        minutes: template.minutes,
      );
    }
  }

  final stretchingItems = card.stretchingSlots.map((slot) {
    final template = libraries.stretchings[slot.stretchingId];
    if (template == null) {
      return ResolvedStretching(
        slotId: slot.slotId,
        description: missingLabel,
        repetitions: 0,
        isMissing: true,
      );
    }
    return ResolvedStretching(
      slotId: slot.slotId,
      description: template.description,
      repetitions: template.repetitions,
    );
  }).toList();

  final exercises = card.exerciseSlots.map((slot) {
    final template = libraries.exercises[slot.exerciseId];
    if (template == null) {
      return ResolvedExercise(
        slotId: slot.slotId,
        title: missingLabel,
        series: 0,
        repetitions: 0,
        isMissing: true,
      );
    }
    return ResolvedExercise(
      slotId: slot.slotId,
      title: template.title,
      series: template.series,
      repetitions: template.repetitions,
      description: template.description,
    );
  }).toList();

  return ResolvedRoutine(
    id: card.id,
    title: card.title,
    description: card.description,
    warmUp: warmUp,
    warmUpPlacement: card.warmUpPlacement,
    stretchingItems: stretchingItems,
    exercises: exercises,
  );
}
