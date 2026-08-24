import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmailPassword implements UseCase<UserEntity, RegisterWithEmailPasswordParams> {
  final AuthRepository repository;

  const RegisterWithEmailPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterWithEmailPasswordParams params) {
    return repository.registerWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterWithEmailPasswordParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterWithEmailPasswordParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
