import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and notifies the app UI language (es / en).
class LocaleService extends ChangeNotifier {
  LocaleService._();

  static final LocaleService instance = LocaleService._();

  static const _localeKey = 'app_locale';
  static const supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];

  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == 'es') {
      _locale = const Locale('es');
    } else if (code == 'en') {
      _locale = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode)) {
      return;
    }
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Locale resolve(Locale? deviceLocale) {
    if (_locale != null) {
      return _locale!;
    }
    if (deviceLocale != null) {
      for (final supported in supportedLocales) {
        if (supported.languageCode == deviceLocale.languageCode) {
          return supported;
        }
      }
    }
    return const Locale('es');
  }
}
