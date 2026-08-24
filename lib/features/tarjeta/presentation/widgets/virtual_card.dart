import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/convenio_entity.dart';

/// Identidad visual de cada tarjeta. Cada convenio pertenece a una marca
/// distinta y debe verse como tal (colores, marca de agua y wordmark
/// propios) — no como una plantilla gris repetida con solo el texto cambiado.
enum CardBrand { fybeca, sanaSana, empleados }

extension CardBrandFromConvenio on CardBrand {
  /// Resuelve la marca visual a partir del id del convenio mock
  /// (`vcon`, `fybeca`, `sana-sana` — ver TarjetaMockDataSource). Si el
  /// backend real trae otros ids, ampliar este mapeo aquí, en un solo lugar.
  static CardBrand fromConvenioId(String convenioId) {
    switch (convenioId) {
      case 'fybeca':
        return CardBrand.fybeca;
      case 'sana-sana':
        return CardBrand.sanaSana;
      default:
        return CardBrand.empleados;
    }
  }
}

class _CardTheme {
  final List<Color> gradient;
  final Color accent;
  final Color chip;
  final String wordmark;
  final IconData markIcon;
  final bool showGroupStripes;

  const _CardTheme({
    required this.gradient,
    required this.accent,
    required this.chip,
    required this.wordmark,
    required this.markIcon,
    this.showGroupStripes = false,
  });

  static const fybeca = _CardTheme(
    gradient: [AppColors.primaryNavy, Color(0xFF122A47)],
    accent: AppColors.brandRed,
    chip: Color(0xFFE8C77A),
    wordmark: 'Fybeca',
    markIcon: Icons.add_circle,
  );

  static const sanaSana = _CardTheme(
    gradient: [AppColors.sanaSanaGreen, Color(0xFF01381C)],
    accent: AppColors.sanaSanaLightGreen,
    chip: Color(0xFFCFE8B0),
    wordmark: 'Sana Sana',
    markIcon: Icons.eco,
  );

  static const empleados = _CardTheme(
    gradient: [AppColors.employeeGraphite, Color(0xFF14161A)],
    accent: AppColors.employeeSteel,
    chip: Color(0xFFC7CDD4),
    wordmark: 'Tarjeta Empresarial',
    markIcon: Icons.workspace_premium_outlined,
    showGroupStripes: true,
  );

  static _CardTheme of(CardBrand brand) {
    switch (brand) {
      case CardBrand.fybeca:
        return fybeca;
      case CardBrand.sanaSana:
        return sanaSana;
      case CardBrand.empleados:
        return empleados;
    }
  }
}

/// Tarjeta virtual con identidad de marca propia. Úsala con [VirtualCard.brand]
/// directo, o con [VirtualCard.forConvenio] para resolver la marca a partir
/// del convenio (recomendado: así un nuevo convenio del backend real hereda
/// automáticamente el diseño que le corresponda).
class VirtualCard extends StatelessWidget {
  final CardBrand brand;
  final String tag;
  final String maskedNumber;
  final double cupoDisponible;

  const VirtualCard({
    super.key,
    required this.brand,
    required this.tag,
    required this.maskedNumber,
    required this.cupoDisponible,
  });

  factory VirtualCard.forConvenio(ConvenioEntity convenio, {String? tag}) {
    return VirtualCard(
      brand: CardBrandFromConvenio.fromConvenioId(convenio.id),
      tag: tag ?? convenio.etiqueta,
      maskedNumber: convenio.tarjetaEnmascarada,
      cupoDisponible: convenio.cupoDisponible,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _CardTheme.of(brand);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradient,
          ),
          border: Border(bottom: BorderSide(color: theme.accent, width: 3)),
          boxShadow: [
            BoxShadow(
              color: theme.gradient.first.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (theme.showGroupStripes) _GroupStripes(accent: theme.accent),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          theme.wordmark,
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(theme.markIcon, size: 16, color: theme.accent),
                      ],
                    ),
                    Text(
                      tag.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  width: 34,
                  height: 26,
                  decoration: BoxDecoration(
                    color: theme.chip,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'CRÉDITO DISPONIBLE',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${cupoDisponible.toStringAsFixed(2)}',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.white,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maskedNumber,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'VIRTUAL',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Franjas diagonales que representan a las marcas afiliadas del grupo
/// (rojo Fybeca, verde Sana Sana, naranja del resto de aliados) — solo en la
/// tarjeta de Empleados, que no pertenece a una farmacia específica sino al
/// grupo empresarial completo.
class _GroupStripes extends StatelessWidget {
  final Color accent;

  const _GroupStripes({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -30,
      right: -40,
      child: Transform.rotate(
        angle: 0.55,
        child: Row(
          children: [
            _stripe(AppColors.brandRed),
            const SizedBox(width: 6),
            _stripe(AppColors.sanaSanaLightGreen),
            const SizedBox(width: 6),
            _stripe(AppColors.brandOrange),
          ],
        ),
      ),
    );
  }

  Widget _stripe(Color color) {
    return Container(
      width: 14,
      height: 140,
      color: color.withValues(alpha: 0.55),
    );
  }
}
