import 'package:flutter/material.dart';

import 'package:life_fit/core/settings/widgets/settings_panel.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/app_popup_dialog.dart';

class SettingsDialog {
  SettingsDialog._();

  static Future<void> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AppPopupDialog(
        title: l10n.settingsTitle,
        child: const SettingsPanel(),
      ),
    );
  }
}
