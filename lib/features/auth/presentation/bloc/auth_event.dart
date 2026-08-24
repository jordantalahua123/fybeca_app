part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Se dispara al arrancar la app para saber si ya hay sesión activa.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginWithEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class AuthLoginWithGoogleRequested extends AuthEvent {
  const AuthLoginWithGoogleRequested();
}

class AuthLoginWithMicrosoftRequested extends AuthEvent {
  const AuthLoginWithMicrosoftRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
