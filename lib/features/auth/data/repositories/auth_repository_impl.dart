import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _authenticate(
      () => remoteDataSource.loginWithEmailAndPassword(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _authenticate(
      () => remoteDataSource.registerWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() {
    return _authenticate(remoteDataSource.loginWithGoogle);
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithMicrosoft() {
    return _authenticate(remoteDataSource.loginWithMicrosoft);
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await localDataSource.clearUser();
    return const Right(null);
  }

  Future<Either<Failure, UserEntity>> _authenticate(
    Future<UserModel> Function() action,
  ) async {
    try {
      final user = await action();
      await localDataSource.cacheUser(user);
      return Right(user);
    } on AuthMockException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
