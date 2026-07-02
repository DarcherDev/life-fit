import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
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
                AppNavigation.openSettings(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_heart_outlined),
              title: Text(l10n.myProcessTitle),
              subtitle: Text(l10n.myProcessSubtitle),
              onTap: () {
                Navigator.pop(context);
                AppNavigation.openMyProcess(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
