import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail implements UseCase<UserEntity, LoginWithEmailParams> {
  final AuthRepository repository;

  const LoginWithEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithEmailParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
