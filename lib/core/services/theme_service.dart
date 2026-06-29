import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferencia de tema: claro, oscuro o seguir el sistema.
enum AppThemePreference {
  light,
  dark,
  system;

  static AppThemePreference? fromStorage(String? value) {
    switch (value) {
      case 'light':
        return AppThemePreference.light;
      case 'dark':
        return AppThemePreference.dark;
      case 'system':
        return AppThemePreference.system;
      default:
        return null;
    }
  }

  String toStorage() => name;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }
}

/// Persiste y notifica el modo de tema de la app.
///
/// Sin preferencia guardada, [AppThemePreference.system] sigue el tema del
/// dispositivo (claro u oscuro). El usuario puede cambiarlo en cualquier momento.
class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const _themeKey = 'app_theme';

  AppThemePreference _preference = AppThemePreference.system;
  bool _hasStoredPreference = false;

  AppThemePreference get preference => _preference;

  bool get hasStoredPreference => _hasStoredPreference;

  ThemeMode get themeMode => _preference.themeMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = AppThemePreference.fromStorage(prefs.getString(_themeKey));
    if (stored != null) {
      _preference = stored;
      _hasStoredPreference = true;
    } else {
      _preference = AppThemePreference.system;
      _hasStoredPreference = false;
    }
  }

  Future<void> setPreference(AppThemePreference preference) async {
    if (_preference == preference && _hasStoredPreference) {
      return;
    }
    _preference = preference;
    _hasStoredPreference = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, preference.toStorage());
  }
}
