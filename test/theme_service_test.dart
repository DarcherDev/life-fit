import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/theme_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ThemeService.instance.init();
  });

  test('por defecto usa tema del sistema', () {
    expect(ThemeService.instance.preference, AppThemePreference.system);
    expect(ThemeService.instance.themeMode, ThemeMode.system);
  });

  test('persiste preferencia de tema oscuro', () async {
    await ThemeService.instance.setPreference(AppThemePreference.dark);

    expect(ThemeService.instance.preference, AppThemePreference.dark);
    expect(ThemeService.instance.themeMode, ThemeMode.dark);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_theme'), 'dark');
  });

  test('restaura preferencia guardada al iniciar', () async {
    SharedPreferences.setMockInitialValues({'app_theme': 'light'});
    await ThemeService.instance.init();

    expect(ThemeService.instance.preference, AppThemePreference.light);
    expect(ThemeService.instance.themeMode, ThemeMode.light);
  });
}
