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
import 'register_page.dart';

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
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppLogo()),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Bienvenido de nuevo',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ),
                      const SizedBox(height: 36),
                      AppTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        prefixIcon: const Icon(Icons.mail_outline),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            label: 'Iniciar sesión',
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
                        onPressed: () =>
                            context.read<AuthBloc>().add(const AuthLoginWithGoogleRequested()),
                      ),
                      const SizedBox(height: 12),
                      SocialLoginButton(
                        icon: const MicrosoftLogo(),
                        label: 'Continuar con Microsoft',
                        onPressed: () =>
                            context.read<AuthBloc>().add(const AuthLoginWithMicrosoftRequested()),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('¿No tienes cuenta?', style: AppTextStyles.bodySecondary),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegisterPage()),
                            ),
                            child: const Text('Regístrate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Cuenta de prueba: demo@fybeca.com / 123456',
                          style: AppTextStyles.caption.copyWith(color: AppColors.mutedBlueGray),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
