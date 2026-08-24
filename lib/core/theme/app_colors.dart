import 'package:flutter/material.dart';

/// Paleta oficial de Fybeca, extraída de fybeca.com (CSS de producción y
/// muestreo de píxeles del logo oficial). No son colores inventados.
class AppColors {
  AppColors._();

  // Marca (Fybeca)
  static const Color primaryNavy = Color(0xFF203A5D);
  static const Color primaryBlue = Color(0xFF2558A4);
  static const Color accentCyan = Color(0xFF00C7EB);
  static const Color brandRed = Color(0xFFE40520);
  static const Color brandOrange = Color(0xFFFF8700);
  static const Color brandGreen = Color(0xFF0B6040);

  // Marca (Sana Sana — verde extraído de sanasana.com.ec: CSS de producción
  // #007938/#7FAE27 + muestreo de píxeles del favicon oficial #70B544, y el
  // fondo mint #eef3e3 que usan en su propio sitio para no saturar de verde)
  static const Color sanaSanaGreen = Color(0xFF007938);
  static const Color sanaSanaLightGreen = Color(0xFF7FAE27);
  static const Color sanaSanaMint = Color(0xFFEEF3E3);

  // Marca (Tarjeta de Empleados — identidad neutra del grupo corporativo,
  // no de una farmacia específica: grafito con acentos plateados)
  static const Color employeeGraphite = Color(0xFF2B2E33);
  static const Color employeeSteel = Color(0xFFB9C2CC);

  // Neutros
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color mutedBlueGray = Color(0xFF888FA4);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFDEE2E6);
  static const Color white = Color(0xFFFFFFFF);

  // Semánticos (mapeados a los mismos tonos de marca, no inventados)
  static const Color success = brandGreen;
  static const Color warning = brandOrange;
  static const Color error = brandRed;
  static const Color info = accentCyan;
}
