import '../l10n/app_localizations.dart';
import '../models/checklist_item.dart';

extension ChecklistItemL10n on ChecklistItem {
  String localizedSubtitle(AppLocalizations l10n) {
    if (series != null && repetitions != null) {
      return l10n.seriesRepsFormat(series!, repetitions!);
    }
    return description;
  }
}
