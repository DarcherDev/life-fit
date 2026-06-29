import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/locale_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
  });

  test('sin preferencia guardada usa idioma del dispositivo si es soportado', () {
    final service = LocaleService.instance;

    expect(
      service.resolve(const Locale('en')),
      const Locale('en'),
    );
    expect(
      service.resolve(const Locale('es')),
      const Locale('es'),
    );
  });

  test('sin preferencia guardada usa inglés si el dispositivo no es soportado', () {
    expect(
      LocaleService.instance.resolve(const Locale('fr')),
      LocaleService.fallbackLocale,
    );
    expect(
      LocaleService.instance.resolve(const Locale('de')),
      LocaleService.fallbackLocale,
    );
  });

  test('needsLocalePrompt solo si no hay guardado y dispositivo no soportado', () {
    final service = LocaleService.instance;

    expect(service.needsLocalePrompt(const Locale('en')), isFalse);
    expect(service.needsLocalePrompt(const Locale('es')), isFalse);
    expect(service.needsLocalePrompt(const Locale('fr')), isTrue);
  });

  test('persiste idioma elegido por el usuario', () async {
    await LocaleService.instance.setLocale(const Locale('es'));

    expect(LocaleService.instance.locale, const Locale('es'));
    expect(LocaleService.instance.hasStoredLocale, isTrue);
    expect(LocaleService.instance.needsLocalePrompt(const Locale('fr')), isFalse);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_locale'), 'es');
  });

  test('preferencia guardada tiene prioridad sobre el dispositivo', () async {
    await LocaleService.instance.setLocale(const Locale('en'));

    expect(
      LocaleService.instance.resolve(const Locale('es')),
      const Locale('en'),
    );
  });
}
