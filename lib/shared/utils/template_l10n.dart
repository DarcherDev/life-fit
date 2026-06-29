import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/resolved_routine.dart';

extension ExerciseTemplateL10n on ExerciseTemplate {
  String localizedSubtitle(AppLocalizations l10n, {WeightUnit? unit}) {
    final parts = <String>[l10n.seriesRepsFormat(series, repetitions)];
    if (weightKg != null) {
      parts.add(
        formatWeight(
          weightKg,
          unit ?? WeightUnitService.instance.unit,
          l10n,
        ),
      );
    }
    return parts.join(' · ');
  }
}

extension ResolvedExerciseL10n on ResolvedExercise {
  String localizedSubtitle(AppLocalizations l10n, {WeightUnit? unit}) {
    final parts = <String>[l10n.seriesRepsFormat(series, repetitions)];
    if (weightKg != null) {
      parts.add(
        formatWeight(
          weightKg,
          unit ?? WeightUnitService.instance.unit,
          l10n,
        ),
      );
    }
    return parts.join(' · ');
  }
}
