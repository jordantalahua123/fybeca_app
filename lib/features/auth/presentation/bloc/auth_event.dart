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

class AuthLoginRequested extends AuthEvent {
  final String identification;
  final String password;

  const AuthLoginRequested({
    required this.identification,
    required this.password,
  });

  @override
  List<Object?> get props => [identification, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
