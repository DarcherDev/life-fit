import 'package:flutter/material.dart';

import 'package:life_fit/core/about/widgets/about_dialog.dart' show AppAboutDialog;
import 'package:life_fit/core/import_export/widgets/export_routines_dialog.dart';
import 'package:life_fit/core/import_export/widgets/import_routines_dialog.dart';
import 'package:life_fit/core/profile/widgets/my_process_dialog.dart';
import 'package:life_fit/core/settings/widgets/settings_dialog.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        l10n.appTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(l10n.settingsTitle),
                    subtitle: Text(l10n.settingsMenuSubtitle),
                    onTap: () {
                      Navigator.pop(context);
                      SettingsDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.monitor_heart_outlined),
                    title: Text(l10n.myProcessTitle),
                    subtitle: Text(l10n.myProcessSubtitle),
                    onTap: () {
                      Navigator.pop(context);
                      MyProcessDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: Text(l10n.exportRoutinesTitle),
                    subtitle: Text(l10n.exportRoutinesSubtitle),
                    onTap: () {
                      Navigator.pop(context);
                      ExportRoutinesDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: Text(l10n.importRoutinesTitle),
                    subtitle: Text(l10n.importRoutinesSubtitle),
                    onTap: () {
                      Navigator.pop(context);
                      ImportRoutinesDialog.show(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutTitle),
              onTap: () {
                Navigator.pop(context);
                AppAboutDialog.show(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
