import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_divider.dart';
import '../widgets/social_login_button.dart';
import 'google_auth_flow_page.dart';
import 'microsoft_auth_flow_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _continueWithGoogle() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const GoogleAuthFlowPage()));
  }

  void _continueWithMicrosoft() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MicrosoftAuthFlowPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
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
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryNavy.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
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
                              'Usa tu correo corporativo para continuar.',
                              style: AppTextStyles.bodySecondary,
                            ),
                            const SizedBox(height: 24),
                            AppTextField(
                              controller: _emailController,
                              label: 'Correo corporativo',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                              prefixIcon: const Icon(Icons.mail_outline),
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
                            const SizedBox(height: 24),
                            const AuthDivider(),
                            const SizedBox(height: 20),
                            SocialLoginButton(
                              icon: const GoogleLogo(),
                              label: 'Continuar con Google',
                              onPressed: _continueWithGoogle,
                            ),
                            const SizedBox(height: 12),
                            SocialLoginButton(
                              icon: const MicrosoftLogo(),
                              label: 'Continuar con Microsoft',
                              onPressed: _continueWithMicrosoft,
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
