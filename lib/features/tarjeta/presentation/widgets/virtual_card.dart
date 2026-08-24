import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Reproduce la tarjeta virtual navy del portal web: chip dorado, número
/// enmascarado y cupo disponible.
class VirtualCard extends StatelessWidget {
  final String tag;
  final String maskedNumber;
  final double cupoDisponible;

  const VirtualCard({
    super.key,
    required this.tag,
    required this.maskedNumber,
    required this.cupoDisponible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryNavy, Color(0xFF122A47)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: const Border(
          bottom: BorderSide(color: AppColors.brandRed, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fybeca',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
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
              color: const Color(0xFFE8C77A),
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
    );
  }
}
