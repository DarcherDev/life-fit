import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';

extension ExerciseTemplateL10n on ExerciseTemplate {
  String localizedSubtitle(AppLocalizations l10n) {
    return l10n.seriesRepsFormat(series, repetitions);
  }
}
