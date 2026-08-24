import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identificationController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identificationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoAccess() {
    _identificationController.text = AuthMockDataSource.demoIdentification;
    _passwordController.text = AuthMockDataSource.demoPassword;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          identification: _identificationController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(scale: 1.15)),
                    const SizedBox(height: 6),
                    Text(
                      'Tu cupo empresarial, siempre contigo.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                          top: BorderSide(color: AppColors.brandRed, width: 4),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'BIENVENIDO',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.brandRed,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ingresa a tus tarjetas',
                              style: AppTextStyles.headline,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Usa las credenciales asociadas a tu convenio empresarial.',
                              style: AppTextStyles.bodySecondary,
                            ),
                            const SizedBox(height: 24),
                            AppTextField(
                              controller: _identificationController,
                              label: 'Número de identificación',
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.notEmpty(
                                v,
                                message: 'Ingresa tu cédula.',
                              ),
                              prefixIcon: const Icon(Icons.badge_outlined),
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _passwordController,
                              label: 'Contraseña',
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              validator: (v) => Validators.notEmpty(
                                v,
                                message: 'Ingresa tu contraseña.',
                              ),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: TextButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                child: Text(
                                  _obscurePassword ? 'Ver' : 'Ocultar',
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return AppButton(
                                  label: 'Ingresar a mi cuenta',
                                  isLoading: state is AuthLoading,
                                  onPressed: _submit,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _fillDemoAccess,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.badge_outlined,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Acceso de demostración',
                                            style: AppTextStyles.caption,
                                          ),
                                          Text(
                                            'CI: ${AuthMockDataSource.demoIdentification} · Clave: ${AuthMockDataSource.demoPassword}',
                                            style: AppTextStyles.bodySecondary
                                                .copyWith(fontSize: 12.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Completar datos',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primaryNavy,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 14,
                                  color: AppColors.mutedBlueGray,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Tus datos se utilizan únicamente para validar tu acceso.',
                                    style: AppTextStyles.caption,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
