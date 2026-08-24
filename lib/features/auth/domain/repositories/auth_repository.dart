import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contrato que la capa de datos debe cumplir. El dominio y la presentación
/// (BLoC) solo dependen de esta interfaz: hoy la implementa un mock local,
/// mañana un cliente REST contra el backend Spring Boot, sin tocar nada aquí.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, UserEntity>> loginWithMicrosoft();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
