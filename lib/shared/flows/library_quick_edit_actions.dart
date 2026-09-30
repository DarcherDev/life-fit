import 'package:flutter/material.dart';

import 'package:life_fit/core/repositories/stretching_template_repository.dart';
import 'package:life_fit/core/repositories/warm_up_template_repository.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/number_edit_dialog.dart';

typedef NumberPrompt = Future<int?> Function(
  BuildContext context, {
  required String title,
  required String itemName,
  required String label,
  required int initialValue,
});

/// Edición rápida de plantillas de biblioteca desde pantallas de rutina.
class LibraryQuickEditActions {
  LibraryQuickEditActions({
    required WarmUpTemplateRepository warmUpTemplates,
    required StretchingTemplateRepository stretchingTemplates,
    NumberPrompt? promptNumber,
  })  : _warmUpTemplates = warmUpTemplates,
        _stretchingTemplates = stretchingTemplates,
        _promptNumber = promptNumber ?? NumberEditDialog.show;

  final WarmUpTemplateRepository _warmUpTemplates;
  final StretchingTemplateRepository _stretchingTemplates;
  final NumberPrompt _promptNumber;

  /// Devuelve `true` si se guardó un valor distinto.
  Future<bool> editWarmUpMinutes(BuildContext context, String warmUpId) async {
    final template = _warmUpTemplates.getWarmUpTemplateById(warmUpId);
    if (template == null) {
      return false;
    }

    final l10n = AppLocalizations.of(context);
    final minutes = await _promptNumber(
      context,
      title: l10n.editWarmUpTemplate,
      itemName: template.description,
      label: l10n.warmUpMinutesLabel,
      initialValue: template.minutes,
    );
    if (minutes == null || minutes == template.minutes) {
      return false;
    }

    await _warmUpTemplates.upsertWarmUpTemplate(
      template.copyWith(minutes: minutes),
    );
    return true;
  }

  /// Devuelve `true` si se guardó un valor distinto.
  Future<bool> editStretchingRepetitions(
    BuildContext context,
    String stretchingId,
  ) async {
    final template = _stretchingTemplates.getStretchingTemplateById(
      stretchingId,
    );
    if (template == null) {
      return false;
    }

    final l10n = AppLocalizations.of(context);
    final repetitions = await _promptNumber(
      context,
      title: l10n.editStretchingTemplate,
      itemName: template.description,
      label: l10n.stretchingRepetitionsLabel,
      initialValue: template.repetitions,
    );
    if (repetitions == null || repetitions == template.repetitions) {
      return false;
    }

    await _stretchingTemplates.upsertStretchingTemplate(
      template.copyWith(repetitions: repetitions),
    );
    return true;
  }
}
