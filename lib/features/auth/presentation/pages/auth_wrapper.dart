import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

/// Punto de decisión de la app: mientras se verifica la sesión muestra un
/// loader, y luego enruta a Home o Login según el estado del AuthBloc.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return HomePage(user: state.user);
        }
        if (state is AuthInitial || state is AuthSessionChecking) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return const LoginPage();
      },
    );
  }
}
