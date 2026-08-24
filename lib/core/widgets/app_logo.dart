import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Logo oficial de Fybeca (`assets/images/logo_fybeca.png`), sobre una
/// placa blanca — el archivo trae fondo blanco opaco, no transparente, así
/// que necesita ese respaldo para verse bien sobre el navy del login. Si el
/// asset no está disponible, cae a un wordmark de texto simple.
class AppLogo extends StatelessWidget {
  final double scale;

  const AppLogo({super.key, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 12 * scale),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_fybeca.png',
        height: 42 * scale,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Text(
          'Fybeca',
          style: GoogleFonts.ubuntu(
            color: AppColors.primaryNavy,
            fontSize: 26 * scale,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
