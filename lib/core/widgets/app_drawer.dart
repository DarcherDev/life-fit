import 'package:flutter/material.dart';

import 'package:life_fit/core/services/locale_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                l10n.settingsTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: ThemeService.instance,
              builder: (context, _) {
                final current = ThemeService.instance.preference;
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6_outlined),
                      title: Text(l10n.themeMenu),
                      subtitle: Text(_themeLabel(l10n, current)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SegmentedButton<AppThemePreference>(
                        segments: [
                          ButtonSegment(
                            value: AppThemePreference.light,
                            icon: const Icon(Icons.light_mode, size: 18),
                            label: Text(l10n.themeLight),
                          ),
                          ButtonSegment(
                            value: AppThemePreference.dark,
                            icon: const Icon(Icons.dark_mode, size: 18),
                            label: Text(l10n.themeDark),
                          ),
                          ButtonSegment(
                            value: AppThemePreference.system,
                            icon: const Icon(Icons.brightness_auto, size: 18),
                            label: Text(l10n.themeSystem),
                          ),
                        ],
                        selected: {current},
                        onSelectionChanged: (value) {
                          ThemeService.instance.setPreference(value.first);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 24),
            AnimatedBuilder(
              animation: LocaleService.instance,
              builder: (context, _) {
                final currentLocale =
                    LocaleService.instance.locale?.languageCode ??
                        Localizations.localeOf(context).languageCode;
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(l10n.languageMenu),
                    ),
                    RadioListTile<String>(
                      value: 'es',
                      groupValue: currentLocale,
                      title: Text(l10n.languageSpanish),
                      onChanged: (value) {
                        if (value != null) {
                          LocaleService.instance.setLocale(Locale(value));
                        }
                      },
                    ),
                    RadioListTile<String>(
                      value: 'en',
                      groupValue: currentLocale,
                      title: Text(l10n.languageEnglish),
                      onChanged: (value) {
                        if (value != null) {
                          LocaleService.instance.setLocale(Locale(value));
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 24),
            AnimatedBuilder(
              animation: WeightUnitService.instance,
              builder: (context, _) {
                final current = WeightUnitService.instance.unit;
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.fitness_center_outlined),
                      title: Text(l10n.weightUnitTitle),
                    ),
                    RadioListTile<WeightUnit>(
                      value: WeightUnit.kg,
                      groupValue: current,
                      title: Text(l10n.weightUnitKg),
                      onChanged: (value) {
                        if (value != null) {
                          WeightUnitService.instance.setUnit(value);
                        }
                      },
                    ),
                    RadioListTile<WeightUnit>(
                      value: WeightUnit.lb,
                      groupValue: current,
                      title: Text(l10n.weightUnitLb),
                      onChanged: (value) {
                        if (value != null) {
                          WeightUnitService.instance.setUnit(value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, AppThemePreference preference) {
    switch (preference) {
      case AppThemePreference.light:
        return l10n.themeLight;
      case AppThemePreference.dark:
        return l10n.themeDark;
      case AppThemePreference.system:
        return l10n.themeSystem;
    }
  }
}
