import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tipografía de Fybeca: Ubuntu es la fuente dominante del sitio (botones,
/// banners, breadcrumbs); Montserrat aparece como fuente de refuerzo en
/// títulos destacados.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.ubuntu(color: AppColors.textPrimary);

  static TextStyle get displayLarge => GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryNavy,
      );

  static TextStyle get headline => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryNavy,
      );

  static TextStyle get title => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySecondary => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
}
