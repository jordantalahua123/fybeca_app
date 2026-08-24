import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailPassword implements UseCase<UserEntity, LoginWithEmailPasswordParams> {
  final AuthRepository repository;

  const LoginWithEmailPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithEmailPasswordParams params) {
    return repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailPasswordParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
