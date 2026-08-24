import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_with_email_password.dart';
import '../../features/auth/domain/usecases/login_with_google.dart';
import '../../features/auth/domain/usecases/login_with_microsoft.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register_with_email_password.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registra todas las dependencias de la app. Para cambiar de mock a backend
/// real, solo se reemplaza el registro de [AuthRemoteDataSource] aquí abajo;
/// nada más en la app necesita cambiar.
void setupLocator() {
  // Feature: Auth
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(AuthMockDataSource.new)
    ..registerLazySingleton<AuthLocalDataSource>(AuthInMemoryDataSource.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton(() => LoginWithEmailPassword(sl()))
    ..registerLazySingleton(() => RegisterWithEmailPassword(sl()))
    ..registerLazySingleton(() => LoginWithGoogle(sl()))
    ..registerLazySingleton(() => LoginWithMicrosoft(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerFactory(
      () => AuthBloc(
        loginWithEmailPassword: sl(),
        registerWithEmailPassword: sl(),
        loginWithGoogle: sl(),
        loginWithMicrosoft: sl(),
        getCurrentUser: sl(),
        logout: sl(),
      ),
    );
}
