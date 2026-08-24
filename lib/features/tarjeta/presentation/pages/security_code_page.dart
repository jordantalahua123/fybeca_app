import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/convenio_entity.dart';
import '../bloc/convenios/convenios_bloc.dart';
import '../bloc/security_code/security_code_bloc.dart';

/// Contenido de la pestaña "Código" dentro de [MainShell]. Lee tanto el
/// [SecurityCodeBloc] (el código y su cuenta regresiva) como el
/// [ConveniosBloc] (para mostrar los datos del convenio al que pertenece el
/// código activo) — ambos provistos por el shell. No trae Scaffold/AppBar ni
/// recibe el convenio por constructor: siempre resuelve el convenio del
/// código activo por su `convenioId`, así se mantiene correcto aunque el
/// usuario cambie la selección en la pestaña Convenios sin regenerar.
class SecurityCodePage extends StatelessWidget {
  const SecurityCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<SecurityCodeBloc, SecurityCodeState>(
          listener: (context, state) {
            if (state is SecurityCodeUsed) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Compra simulada exitosamente.'),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is SecurityCodeInitial) {
              return const _MessagePanel(
                icon: Icons.confirmation_number_outlined,
                title: 'Aún no tienes un código',
                message:
                    'Ve a la pestaña Convenios, elige tu tarjeta y genera tu código de seguridad.',
                color: AppColors.mutedBlueGray,
              );
            }
            if (state is SecurityCodeLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is SecurityCodeError) {
              return _MessagePanel(
                icon: Icons.error_outline,
                title: 'No se pudo generar el código',
                message: state.message,
              );
            }
            if (state is SecurityCodeUsed) {
              return _MessagePanel(
                icon: Icons.check_circle_outline,
                title: 'Código utilizado',
                message: 'La compra fue simulada correctamente en caja.',
                color: AppColors.success,
                action: AppButton(
                  label: 'Generar otro código',
                  onPressed: () => context.read<SecurityCodeBloc>().add(
                    SecurityCodeGenerateRequested(state.convenioId),
                  ),
                ),
              );
            }
            if (state is SecurityCodeExpired) {
              return _MessagePanel(
                icon: Icons.timer_off_outlined,
                title: 'El código expiró',
                message: 'Genera uno nuevo para continuar con tu compra.',
                color: AppColors.warning,
                action: AppButton(
                  label: 'Volver a generar',
                  onPressed: () => context.read<SecurityCodeBloc>().add(
                    SecurityCodeGenerateRequested(state.convenioId),
                  ),
                ),
              );
            }

            final active = state as SecurityCodeActive;
            final convenio = _resolveConvenio(context, active.code.convenioId);
            if (convenio == null) {
              // No debería ocurrir en el flujo normal (el convenio ya se
              // conocía cuando se generó el código), pero evita un crash si
              // los convenios aún no han terminado de cargar.
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _ActiveCodeView(convenio: convenio, state: active);
          },
        ),
      ),
    );
  }

  ConvenioEntity? _resolveConvenio(BuildContext context, String convenioId) {
    final conveniosState = context.watch<ConveniosBloc>().state;
    if (conveniosState is! ConveniosLoaded) return null;
    for (final convenio in conveniosState.convenios) {
      if (convenio.id == convenioId) return convenio;
    }
    return null;
  }
}

class _ActiveCodeView extends StatelessWidget {
  final ConvenioEntity convenio;
  final SecurityCodeActive state;

  const _ActiveCodeView({required this.convenio, required this.state});

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final code = state.code.code;
    final firstHalf = code.substring(0, 4);
    final secondHalf = code.substring(4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'CÓDIGO DE SEGURIDAD',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.brandRed,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Muéstralo al dependiente',
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Úsalo como validación adicional al momento de pagar.',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Código copiado.')));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstHalf,
                      style: AppTextStyles.displayLarge.copyWith(
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 32, color: AppColors.border),
                    const SizedBox(width: 14),
                    Text(
                      secondHalf,
                      style: AppTextStyles.displayLarge.copyWith(
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Toca para copiar', style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              _formatTime(state.remaining),
              style: AppTextStyles.title.copyWith(color: AppColors.error),
            ),
            const SizedBox(width: 8),
            Text('Tiempo restante', style: AppTextStyles.bodySecondary),
          ],
        ),
        Center(
          child: Text(
            'El código expira automáticamente.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Volver a generar',
          onPressed: () => context.read<SecurityCodeBloc>().add(
            SecurityCodeGenerateRequested(convenio.id),
          ),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: 'Simular uso en caja',
          outlined: true,
          onPressed: () => context.read<SecurityCodeBloc>().add(
            const SecurityCodeSimulateUsoRequested(),
          ),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONVENIO SELECCIONADO',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.brandRed,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(convenio.nombre, style: AppTextStyles.title),
              const Divider(height: 24),
              _InfoRow(label: 'Tarjeta', value: convenio.tarjetaEnmascarada),
              _InfoRow(
                label: 'Código convenio',
                value: convenio.codigoConvenio,
              ),
              _InfoRow(
                label: 'Cupo disponible',
                value: '\$${convenio.cupoDisponible.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Protección del código',
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 6),
              Text(
                '8 dígitos numéricos · 5 minutos · un solo uso. Al volver a generar, el código anterior queda invalidado.',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(
            value,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MessagePanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color? color;
  final Widget? action;

  const _MessagePanel({
    required this.icon,
    required this.title,
    required this.message,
    this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(icon, size: 48, color: effectiveColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    );
  }
}
