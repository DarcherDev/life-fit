import 'package:flutter/material.dart';

/// Colores de marca (azul del icono + naranja complementario).
///
/// Los widgets deben leer los colores de `Theme.of(context).colorScheme`;
/// estas constantes solo alimentan [AppTheme] y los casos semánticos
/// que no dependen del tema.
abstract class AppColors {
  AppColors._();

  static const brandBlue = Color(0xFF3D6BF0);
  static const brandBlueLight = Color(0xFF8FAEFF);
  static const brandBlueDeep = Color(0xFF1E3FA8);

  static const brandOrange = Color(0xFFF97316);
  static const brandOrangeLight = Color(0xFFFF9F5A);

  static const lightBackground = Color(0xFFF4F7FF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFE3EAFD);

  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF0E1320);
  static const darkSurfaceVariant = Color(0xFF161C2C);

  static const success = Color(0xFF16A34A);

  static const confetti = <Color>[
    brandBlue,
    brandBlueLight,
    brandOrange,
    Colors.amber,
    Colors.white,
  ];
}
