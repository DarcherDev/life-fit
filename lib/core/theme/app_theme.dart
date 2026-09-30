import 'package:flutter/material.dart';

import 'package:life_fit/core/theme/app_colors.dart';

/// Temas claro (azul con blanco) y oscuro (azul con negro), con naranja
/// como color complementario (`tertiary`).
abstract class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.brandBlue,
      onPrimary: Colors.white,
      secondary: AppColors.brandBlueDeep,
      onSecondary: Colors.white,
      tertiary: AppColors.brandOrange,
      onTertiary: Colors.white,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceVariant: AppColors.lightSurfaceVariant,
      surfaceTint: AppColors.brandBlue,
    );
    return _build(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandBlue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.brandBlueLight,
      onPrimary: Colors.black,
      secondary: AppColors.brandBlue,
      onSecondary: Colors.white,
      tertiary: AppColors.brandOrangeLight,
      onTertiary: Colors.black,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      surfaceVariant: AppColors.darkSurfaceVariant,
      surfaceTint: AppColors.brandBlueLight,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      useMaterial3: true,
    );
  }
}
