import 'package:flutter/material.dart';

/// Temas claro y oscuro de la app.
abstract class AppTheme {
  AppTheme._();

  /// Verde menta del icono (calendario + mancuerna).
  static const _seedColor = Color(0xFF7CB894);

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
