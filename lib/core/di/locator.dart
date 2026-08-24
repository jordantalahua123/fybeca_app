import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_with_identification.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/tarjeta/data/datasources/tarjeta_remote_data_source.dart';
import '../../features/tarjeta/data/repositories/tarjeta_repository_impl.dart';
import '../../features/tarjeta/domain/repositories/tarjeta_repository.dart';
import '../../features/tarjeta/domain/usecases/generate_security_code.dart';
import '../../features/tarjeta/domain/usecases/get_convenios.dart';
import '../../features/tarjeta/domain/usecases/simulate_uso_en_caja.dart';
import '../../features/tarjeta/presentation/bloc/convenios/convenios_bloc.dart';
import '../../features/tarjeta/presentation/bloc/security_code/security_code_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registra todas las dependencias de la app. Para cambiar de mock a backend
/// real, solo se reemplaza el registro del data source remoto de cada
/// feature aquí abajo; nada más en la app necesita cambiar.
void setupLocator() {
  // Feature: Auth
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(AuthMockDataSource.new)
    ..registerLazySingleton<AuthLocalDataSource>(AuthInMemoryDataSource.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton(() => LoginWithIdentification(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerFactory(
      () => AuthBloc(
        loginWithIdentification: sl(),
        getCurrentUser: sl(),
        logout: sl(),
      ),
    );

  // Feature: Tarjeta empresarial (convenios + código de seguridad)
  sl
    ..registerLazySingleton<TarjetaRemoteDataSource>(TarjetaMockDataSource.new)
    ..registerLazySingleton<TarjetaRepository>(
      () => TarjetaRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetConvenios(sl()))
    ..registerLazySingleton(() => GenerateSecurityCode(sl()))
    ..registerLazySingleton(() => SimulateUsoEnCaja(sl()))
    ..registerFactory(() => ConveniosBloc(getConvenios: sl()))
    ..registerFactory(
      () =>
          SecurityCodeBloc(generateSecurityCode: sl(), simulateUsoEnCaja: sl()),
    );
}
