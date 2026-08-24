import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../tarjeta/presentation/bloc/convenios/convenios_bloc.dart';
import '../../../tarjeta/presentation/widgets/virtual_card.dart';

/// Contenido de la pestaña "Inicio" dentro de [MainShell]. Ya no trae su
/// propio Scaffold/AppBar/BlocProvider: los provee el shell, así todas las
/// pestañas comparten el mismo [ConveniosBloc].
class HomePage extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onGenerateCodeTap;

  const HomePage({
    super.key,
    required this.user,
    required this.onGenerateCodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, ${user.name}', style: AppTextStyles.headline),
            const SizedBox(height: 4),
            Text(
              'Tu cupo empresarial, disponible cuando lo necesites.',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 24),
            BlocBuilder<ConveniosBloc, ConveniosState>(
              builder: (context, state) {
                if (state is ConveniosLoading || state is ConveniosInitial) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is ConveniosError) {
                  return _EmptyState(message: state.message);
                }
                final loaded = state as ConveniosLoaded;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VirtualCard(
                      tag: 'Empresarial',
                      maskedNumber: '•••• •••• •••• 5218',
                      cupoDisponible: loaded.cupoTotal,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: AppColors.primaryNavy,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${loaded.convenios.length} convenios activos',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text('¿Listo para comprar?', style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(
                      'Selecciona un convenio activo y genera un código de seguridad de un solo uso.',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Generar código de seguridad',
                      onPressed: onGenerateCodeTap,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.credit_card_off_outlined, color: AppColors.mutedBlueGray),
          const SizedBox(height: 12),
          Text('Sin convenios activos', style: AppTextStyles.title),
          const SizedBox(height: 4),
          Text(message, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
