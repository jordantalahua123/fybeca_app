import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contrato que la capa de datos debe cumplir. Hoy lo implementa un mock
/// local; cuando el backend Spring Boot esté listo, se reemplaza la
/// implementación sin tocar dominio ni presentación.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, UserEntity>> loginWithMicrosoft();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
