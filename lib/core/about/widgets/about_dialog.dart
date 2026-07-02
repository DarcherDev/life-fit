import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class AppAboutDialog {
  AppAboutDialog._();

  static Future<void> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;

    final versionLabel = packageInfo.buildNumber.isEmpty
        ? packageInfo.version
        : '${packageInfo.version}+${packageInfo.buildNumber}';

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: Text(l10n.aboutTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.aboutVersion(versionLabel),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    AppNavigation.openLicense(context);
                  },
                  child: Text(
                    l10n.licenseLink,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.back),
            ),
          ],
        );
      },
    );
  }
}
