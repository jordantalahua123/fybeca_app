import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../bloc/auth_bloc.dart';

/// Simulación completa de "Continuar con Google": selector de cuenta →
/// pantalla de consentimiento (qué datos comparte Google con la app) →
/// verificación en 2 pasos. No hay ningún SDK de OAuth real detrás — es un
/// mockup fiel al flujo real para poder mostrarlo completo.
class GoogleAuthFlowPage extends StatefulWidget {
  const GoogleAuthFlowPage({super.key});

  @override
  State<GoogleAuthFlowPage> createState() => _GoogleAuthFlowPageState();
}

class _GoogleAuthFlowPageState extends State<GoogleAuthFlowPage> {
  static const _correctOtp = '000000';

  int _step = 0;
  final _otpController = TextEditingController();
  String? _otpError;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _step -= 1;
        _otpError = null;
      });
    }
  }

  void _verifyOtp() {
    if (_otpController.text.trim() == _correctOtp) {
      context.read<AuthBloc>().add(const AuthLoginWithGoogleRequested());
    } else {
      setState(() => _otpError = 'Código incorrecto. Inténtalo de nuevo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _goBack,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) Navigator.of(context).pop();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: switch (_step) {
              0 => _AccountStep(onAccountTap: () => setState(() => _step = 1)),
              1 => _ConsentStep(onContinue: () => setState(() => _step = 2)),
              _ => _OtpStep(
                controller: _otpController,
                error: _otpError,
                onVerify: _verifyOtp,
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _AccountStep extends StatelessWidget {
  final VoidCallback onAccountTap;

  const _AccountStep({required this.onAccountTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Center(child: GoogleLogo(size: 40)),
        const SizedBox(height: 20),
        Center(child: Text('Elige una cuenta', style: AppTextStyles.headline)),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'para continuar a Fybeca Tarjeta Empresarial',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 28),
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onAccountTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF4285F4),
                    child: Icon(Icons.person, color: AppColors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AuthMockDataSource.demoName,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          AuthMockDataSource.demoEmail,
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Disponible próximamente en esta demostración.',
                  ),
                ),
              );
          },
          icon: const Icon(Icons.person_add_alt_outlined, size: 18),
          label: const Text('Usar otra cuenta'),
        ),
      ],
    );
  }
}

class _ConsentStep extends StatelessWidget {
  final VoidCallback onContinue;

  const _ConsentStep({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            const GoogleLogo(size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Fybeca — Tarjeta Empresarial',
                style: AppTextStyles.title,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('¿Deseas continuar?', style: AppTextStyles.headline),
        const SizedBox(height: 8),
        Text(
          'Fybeca — Tarjeta Empresarial podrá acceder a la siguiente información de tu cuenta de Google:',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 20),
        const _ConsentItem(
          icon: Icons.badge_outlined,
          label: 'Tu nombre y foto de perfil',
        ),
        const _ConsentItem(
          icon: Icons.email_outlined,
          label: 'Tu dirección de correo electrónico principal',
        ),
        const Spacer(),
        Text(
          'Al continuar, aceptas compartir esta información con Fybeca — Tarjeta Empresarial. '
          'Puedes revocar el acceso cuando quieras desde tu cuenta de Google.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Cancelar',
                outlined: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(label: 'Continuar', onPressed: onContinue),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ConsentItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ConsentItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.mutedBlueGray),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _OtpStep extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final VoidCallback onVerify;

  const _OtpStep({
    required this.controller,
    required this.error,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        const Center(
          child: Icon(
            Icons.shield_outlined,
            size: 44,
            color: Color(0xFF4285F4),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Verificación en 2 pasos',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Escribe el código de 6 dígitos de tu app de autenticación.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          textAlign: TextAlign.center,
          style: AppTextStyles.headline.copyWith(letterSpacing: 10),
          decoration: InputDecoration(
            counterText: '',
            hintText: '000000',
            errorText: error,
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Código de prueba: 000000',
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return AppButton(
              label: 'Verificar',
              isLoading: state is AuthLoading,
              onPressed: onVerify,
            );
          },
        ),
      ],
    );
  }
}
