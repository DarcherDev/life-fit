import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and notifies the app UI language (es / en).
///
/// Sin preferencia guardada, usa el idioma del dispositivo si es es o en.
/// Si no está soportado, la app arranca en inglés y [needsLocalePrompt] indica
/// que se debe pedir al usuario que elija.
class LocaleService extends ChangeNotifier {
  LocaleService._();

  static final LocaleService instance = LocaleService._();

  static const _localeKey = 'app_locale';
  static const fallbackLocale = Locale('en');

  static const supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];

  Locale? _locale;
  bool _hasStoredLocale = false;

  Locale? get locale => _locale;

  bool get hasStoredLocale => _hasStoredLocale;

  static bool isSupportedLanguageCode(String? code) {
    if (code == null) {
      return false;
    }
    return supportedLocales
        .any((supported) => supported.languageCode == code);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == 'es') {
      _locale = const Locale('es');
      _hasStoredLocale = true;
    } else if (code == 'en') {
      _locale = const Locale('en');
      _hasStoredLocale = true;
    } else {
      _locale = null;
      _hasStoredLocale = false;
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!isSupportedLanguageCode(locale.languageCode)) {
      return;
    }
    _locale = locale;
    _hasStoredLocale = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// True cuando no hay idioma guardado y el dispositivo no es es ni en.
  bool needsLocalePrompt(Locale? deviceLocale) {
    if (_hasStoredLocale) {
      return false;
    }
    return !isSupportedLanguageCode(deviceLocale?.languageCode);
  }

  Locale resolve(Locale? deviceLocale) {
    if (_locale != null) {
      return _locale!;
    }
    if (isSupportedLanguageCode(deviceLocale?.languageCode)) {
      return Locale(deviceLocale!.languageCode);
    }
    return fallbackLocale;
  }
}
