import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/core/import_export/routine_export_service.dart';
import 'package:life_fit/core/import_export/sample_routine_document_builder.dart';
import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/personal_profile_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/app_popup_dialog.dart';

class ExportRoutinesDialog {
  ExportRoutinesDialog._();

  static Future<void> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final copiedMessage = l10n.exportRoutinesCopied;
    PersonalProfile profileReader() => PersonalProfileService.instance.profile;
    WeightUnit weightUnitReader() => WeightUnitService.instance.unit;

    final exportService = RoutineExportService(
      repositories: AppRepositories.instance,
      profileReader: profileReader,
      weightUnitReader: weightUnitReader,
    );
    final hasRoutines = exportService.hasRoutines;
    final json = hasRoutines
        ? exportService.buildJsonString()
        : SampleRoutineDocumentBuilder(
            profileReader: profileReader,
            weightUnitReader: weightUnitReader,
            routineTitle: l10n.exportSampleRoutineTitle,
            routineDescription: l10n.exportSampleRoutineDescription,
          ).buildJsonString();
    final description = hasRoutines
        ? l10n.exportRoutinesDescription
        : l10n.exportRoutinesEmptyDescription;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AppPopupDialog(
        title: l10n.exportRoutinesTitle,
        actions: [
          IconButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final messenger = ScaffoldMessenger.maybeOf(context);
              await Clipboard.setData(ClipboardData(text: json));
              navigator.pop();
              messenger?.showSnackBar(
                SnackBar(content: Text(copiedMessage)),
              );
            },
            icon: const Icon(Icons.copy_outlined),
            tooltip: l10n.exportRoutinesCopy,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                description,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(dialogContext)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      json,
                      style: Theme.of(dialogContext)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
