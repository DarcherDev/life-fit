import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/services/locale_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context).languageCode;
    final currentTheme = ThemeService.instance.preference;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<AppThemePreference>(
            tooltip: l10n.themeMenu,
            icon: Icon(
              currentTheme == AppThemePreference.dark
                  ? Icons.dark_mode
                  : currentTheme == AppThemePreference.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
            ),
            onSelected: ThemeService.instance.setPreference,
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: AppThemePreference.light,
                checked: currentTheme == AppThemePreference.light,
                child: Text(l10n.themeLight),
              ),
              CheckedPopupMenuItem(
                value: AppThemePreference.dark,
                checked: currentTheme == AppThemePreference.dark,
                child: Text(l10n.themeDark),
              ),
              CheckedPopupMenuItem(
                value: AppThemePreference.system,
                checked: currentTheme == AppThemePreference.system,
                child: Text(l10n.themeSystem),
              ),
            ],
          ),
          PopupMenuButton<String>(
            tooltip: l10n.languageMenu,
            icon: const Icon(Icons.language),
            onSelected: (code) {
              LocaleService.instance.setLocale(Locale(code));
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'es',
                checked: currentLocale == 'es',
                child: Text(l10n.languageSpanish),
              ),
              CheckedPopupMenuItem(
                value: 'en',
                checked: currentLocale == 'en',
                child: Text(l10n.languageEnglish),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.homeTagline,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          _HomeOptionCard(
            title: l10n.homeGymDayTitle,
            subtitle: l10n.homeGymDaySubtitle,
            icon: Icons.fitness_center,
            color: Colors.deepOrange,
            onTap: () => AppNavigation.openTodayGym(context),
          ),
          const SizedBox(height: 16),
          _HomeOptionCard(
            title: l10n.homeExercisesTitle,
            subtitle: l10n.homeExercisesSubtitle,
            icon: Icons.dashboard_customize,
            color: Colors.teal,
            onTap: () => AppNavigation.openExercises(context),
          ),
          const SizedBox(height: 16),
          _HomeOptionCard(
            title: l10n.homePlannerTitle,
            subtitle: l10n.homePlannerSubtitle,
            icon: Icons.calendar_month,
            color: Colors.indigo,
            onTap: () => AppNavigation.openPlanner(context),
          ),
        ],
      ),
    );
  }
}

class _HomeOptionCard extends StatelessWidget {
  const _HomeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
