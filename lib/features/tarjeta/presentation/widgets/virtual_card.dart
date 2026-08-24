import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/convenio_entity.dart';

/// Identidad visual de cada tarjeta. Cada convenio pertenece a una marca
/// distinta y debe verse como tal (colores, logo y wordmark propios) — no
/// como una plantilla repetida con solo el texto cambiado.
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
  final Color background;
  final Color? backgroundGradientEnd;
  final Color accent;
  final Color chip;
  final Color onBackground;
  final Color onBackgroundMuted;
  final Color amountColor;
  final String wordmark;
  final IconData markIcon;

  /// Ruta del logo real (la sube el equipo de diseño a `assets/images/`).
  /// Si el archivo aún no existe, se usa automáticamente el wordmark + ícono
  /// como respaldo — ver [errorBuilder] en [VirtualCard.build].
  final String? logoAsset;
  final bool showGroupStripes;
  final bool showWave;
  final bool logoNeedsBackdrop;

  const _CardTheme({
    required this.background,
    this.backgroundGradientEnd,
    required this.accent,
    required this.chip,
    required this.onBackground,
    required this.onBackgroundMuted,
    required this.amountColor,
    required this.wordmark,
    required this.markIcon,
    this.logoAsset,
    this.showGroupStripes = false,
    this.showWave = false,
    this.logoNeedsBackdrop = false,
  });

  static const fybeca = _CardTheme(
    background: AppColors.primaryNavy,
    backgroundGradientEnd: Color(0xFF122A47),
    accent: AppColors.brandRed,
    chip: Color(0xFFE8C77A),
    onBackground: AppColors.white,
    onBackgroundMuted: Color(0xCCFFFFFF),
    amountColor: AppColors.white,
    wordmark: 'Fybeca',
    markIcon: Icons.add_circle,
    logoAsset: 'assets/images/logo_fybeca_tarjeta.png',
  );

  // Verde vivo (no el mint apagado de antes) inspirado en la identidad real
  // de Sana Sana: verde franco + blanco + un detalle rojo, con una ola
  // blanca decorativa como en sus artes de marca.
  static const sanaSana = _CardTheme(
    background: AppColors.sanaSanaLightGreen,
    backgroundGradientEnd: AppColors.sanaSanaGreen,
    accent: AppColors.brandRed,
    chip: AppColors.white,
    onBackground: AppColors.white,
    onBackgroundMuted: Color(0xCCFFFFFF),
    amountColor: AppColors.white,
    wordmark: 'Sana Sana',
    markIcon: Icons.eco,
    logoAsset: 'assets/images/logo_sanaSana.webp',
    showWave: true,
    logoNeedsBackdrop: true,
  );

  static const empleados = _CardTheme(
    background: AppColors.white,
    accent: AppColors.employeeGraphite,
    chip: Color(0xFFE7EAED),
    onBackground: AppColors.textPrimary,
    onBackgroundMuted: AppColors.textSecondary,
    amountColor: AppColors.primaryNavy,
    wordmark: 'Tarjeta Empresarial',
    markIcon: Icons.workspace_premium_outlined,
    logoAsset: 'assets/images/icono_fybeca.png',
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
          gradient: theme.backgroundGradientEnd == null
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.background, theme.backgroundGradientEnd!],
                ),
          color: theme.backgroundGradientEnd == null ? theme.background : null,
          border: Border.all(
            color: AppColors.border,
            width: theme.background == AppColors.white ? 1 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (theme.showWave) const Positioned.fill(child: _SanaSanaWave()),
            if (theme.showGroupStripes) _GroupStripes(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BrandMark(theme: theme),
                    Text(
                      tag.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: theme.onBackgroundMuted,
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
                    color: theme.onBackgroundMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${cupoDisponible.toStringAsFixed(2)}',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: theme.amountColor,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: 46,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maskedNumber,
                      style: AppTextStyles.body.copyWith(
                        color: theme.onBackground.withValues(alpha: 0.85),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'VIRTUAL',
                      style: AppTextStyles.caption.copyWith(
                        color: theme.onBackgroundMuted,
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

class _BrandMark extends StatelessWidget {
  final _CardTheme theme;

  const _BrandMark({required this.theme});

  Widget _fallback() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          theme.wordmark,
          style: AppTextStyles.title.copyWith(
            color: theme.onBackground,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Icon(theme.markIcon, size: 16, color: theme.accent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (theme.logoAsset == null) return _fallback();

    final image = Image.asset(
      theme.logoAsset!,
      height: 22,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );

    if (!theme.logoNeedsBackdrop) return image;

    // Fondo blanco de contraste para que el logo se lea bien sobre la
    // tarjeta verde — igual que en las artes de marca reales de Sana Sana.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: image,
    );
  }
}

/// Ola blanca decorativa (como en los artes de marca de Sana Sana) que le da
/// textura a la tarjeta sin depender de un logo con mascota específica.
class _SanaSanaWave extends StatelessWidget {
  const _SanaSanaWave();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WavePainter());
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.12);
    final path = Path()
      ..moveTo(size.width * 0.55, size.height)
      ..lineTo(size.width * 0.55, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.15,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Franjas diagonales que representan a las marcas afiliadas del grupo
/// (rojo Fybeca, verde Sana Sana, naranja del resto de aliados) — solo en la
/// tarjeta de Empleados, que no pertenece a una farmacia específica sino al
/// grupo empresarial completo.
class _GroupStripes extends StatelessWidget {
  const _GroupStripes();

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
            _stripe(AppColors.sanaSanaGreen),
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
      color: color.withValues(alpha: 0.18),
    );
  }
}
