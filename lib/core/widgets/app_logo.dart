import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Wordmark "Fybeca" replicando el logo oficial (texto azul marino + punto
/// rojo), sin depender de un asset de imagen.
class AppLogo extends StatelessWidget {
  final double fontSize;

  const AppLogo({super.key, this.fontSize = 34});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.displayLarge.copyWith(fontSize: fontSize),
        children: [
          const TextSpan(text: 'Fybeca'),
          TextSpan(text: '•', style: TextStyle(color: AppColors.brandRed)),
          TextSpan(text: 'com', style: TextStyle(fontSize: fontSize * 0.5, color: AppColors.primaryNavy)),
        ],
      ),
    );
  }
}
