part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial, antes de disparar la verificación de sesión.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Verificando si ya existe una sesión activa al arrancar la app.
/// Separado de [AuthLoading] para que el wrapper raíz no tape la pantalla
/// de login mientras el usuario está enviando el formulario.
class AuthSessionChecking extends AuthState {
  const AuthSessionChecking();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
