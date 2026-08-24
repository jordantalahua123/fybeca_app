import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/convenio_entity.dart';
import '../bloc/convenios/convenios_bloc.dart';

/// Contenido de la pestaña "Convenios" dentro de [MainShell]. Comparte el
/// mismo [ConveniosBloc] que la pestaña Inicio (provisto por el shell); no
/// trae Scaffold/AppBar/BlocProvider propios.
class ConveniosPage extends StatelessWidget {
  final void Function(ConvenioEntity convenio) onGenerate;

  const ConveniosPage({super.key, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConveniosBloc, ConveniosState>(
      builder: (context, state) {
        if (state is ConveniosLoading || state is ConveniosInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ConveniosError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.message,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final loaded = state as ConveniosLoaded;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'El cupo mostrado corresponde al convenio activo seleccionado.',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${loaded.convenios.length} activos',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final convenio in loaded.convenios)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ConvenioCard(
                        convenio: convenio,
                        selected: convenio.id == loaded.selectedConvenioId,
                        onTap: () => context.read<ConveniosBloc>().add(
                          ConvenioSelected(convenio.id),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _BottomBar(onGenerate: () => onGenerate(loaded.selected)),
          ],
        );
      },
    );
  }
}

class _ConvenioCard extends StatelessWidget {
  final ConvenioEntity convenio;
  final bool selected;
  final VoidCallback onTap;

  const _ConvenioCard({
    required this.convenio,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryNavy : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  convenio.etiqueta.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedBlueGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? AppColors.primaryNavy : AppColors.border,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(convenio.nombre, style: AppTextStyles.title),
            Text(
              convenio.tarjetaEnmascarada,
              style: AppTextStyles.bodySecondary,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cupo disponible', style: AppTextStyles.caption),
                Text(
                  '\$${convenio.cupoDisponible.toStringAsFixed(2)}',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onGenerate;

  const _BottomBar({required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Listo para comprar?',
                    style: AppTextStyles.title.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'El código será válido por 5 minutos y de un solo uso.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onGenerate,
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Generar código'),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
