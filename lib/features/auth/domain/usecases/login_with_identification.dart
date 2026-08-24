import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithIdentification
    implements UseCase<UserEntity, LoginWithIdentificationParams> {
  final AuthRepository repository;

  const LoginWithIdentification(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(
    LoginWithIdentificationParams params,
  ) {
    return repository.loginWithIdentification(
      identification: params.identification,
      password: params.password,
    );
  }
}

class LoginWithIdentificationParams extends Equatable {
  final String identification;
  final String password;

  const LoginWithIdentificationParams({
    required this.identification,
    required this.password,
  });

  @override
  List<Object?> get props => [identification, password];
}
