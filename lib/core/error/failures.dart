import 'package:equatable/equatable.dart';

/// Errores de negocio, agnósticos de la fuente (API REST, Firebase, mock...).
/// La capa de datos traduce excepciones concretas a estos Failures; el resto
/// de la app (domain/presentation) solo conoce esto.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ocurrió un error en el servidor.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No hay conexión a internet.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No se pudo leer la información local.']);
}
