import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../bloc/auth_bloc.dart';

/// Simulación completa de "Continuar con Microsoft": selector de cuenta →
/// aprobación estilo Microsoft Authenticator (coincidencia de número). No
/// hay ningún SDK de OAuth/MSAL real detrás — es un mockup fiel al flujo
/// real para poder mostrarlo completo.
class MicrosoftAuthFlowPage extends StatefulWidget {
  const MicrosoftAuthFlowPage({super.key});

  @override
  State<MicrosoftAuthFlowPage> createState() => _MicrosoftAuthFlowPageState();
}

class _MicrosoftAuthFlowPageState extends State<MicrosoftAuthFlowPage> {
  static const _correctNumber = '10';

  int _step = 0;
  final _numberController = TextEditingController();
  String? _numberError;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _step -= 1;
        _numberError = null;
      });
    }
  }

  void _approve() {
    if (_numberController.text.trim() == _correctNumber) {
      context.read<AuthBloc>().add(const AuthLoginWithMicrosoftRequested());
    } else {
      setState(() => _numberError = 'Número incorrecto. Inténtalo de nuevo.');
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
            child: _step == 0
                ? _AccountStep(onAccountTap: () => setState(() => _step = 1))
                : _ApprovalStep(
                    controller: _numberController,
                    error: _numberError,
                    onApprove: _approve,
                  ),
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
        const Center(child: MicrosoftLogo(size: 40)),
        const SizedBox(height: 20),
        Center(child: Text('Iniciar sesión', style: AppTextStyles.headline)),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Selecciona una cuenta para continuar a Fybeca Tarjeta Empresarial',
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
                    backgroundColor: Color(0xFF00A4EF),
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

class _ApprovalStep extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final VoidCallback onApprove;

  const _ApprovalStep({
    required this.controller,
    required this.error,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 28),
        const Center(
          child: Icon(
            Icons.verified_user_outlined,
            size: 44,
            color: Color(0xFF00A4EF),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Aprobar solicitud de inicio de sesión',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Abre tu app Microsoft Authenticator y toca el número que se muestra para aprobar la solicitud.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '10',
              style: AppTextStyles.displayLarge.copyWith(
                color: const Color(0xFF00A4EF),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Escribe aquí el número para confirmar:',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          textAlign: TextAlign.center,
          style: AppTextStyles.headline.copyWith(letterSpacing: 6),
          decoration: InputDecoration(
            counterText: '',
            hintText: '00',
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
          'Número de prueba: 10',
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return AppButton(
              label: 'Aprobar',
              isLoading: state is AuthLoading,
              onPressed: onApprove,
            );
          },
        ),
      ],
    );
  }
}
