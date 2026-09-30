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

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final logoSize = constraints.maxHeight * 0.9;
                          return Center(
                            child: Image.asset(
                              'assets/branding/app_icon.png',
                              height: logoSize,
                              width: logoSize,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              semanticLabel: l10n.appTitle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(l10n.settingsTitle),
                    onTap: () {
                      Navigator.pop(context);
                      SettingsDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.monitor_heart_outlined),
                    title: Text(l10n.myProcessTitle),
                    onTap: () {
                      Navigator.pop(context);
                      MyProcessDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: Text(l10n.exportRoutinesTitle),
                    onTap: () {
                      Navigator.pop(context);
                      ExportRoutinesDialog.show(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: Text(l10n.importRoutinesTitle),
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
