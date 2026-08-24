import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Insignia del logo Fybeca: fondo navy redondeado, wordmark en negrita y
/// el tagline "Única en tu vida" en cursiva, tal como aparece en el portal
/// de Tarjeta Empresarial. Es autocontenida (trae su propio fondo), así que
/// se puede usar sobre cualquier color de página.
class AppLogo extends StatelessWidget {
  final double scale;

  const AppLogo({super.key, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 10 * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fybeca',
            style: GoogleFonts.ubuntu(
              color: AppColors.white,
              fontSize: 22 * scale,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text(
            'Única en tu vida',
            style: GoogleFonts.montserrat(
              color: AppColors.white,
              fontSize: 11 * scale,
              fontStyle: FontStyle.italic,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
