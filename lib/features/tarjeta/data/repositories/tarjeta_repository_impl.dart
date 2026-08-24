import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/convenio_entity.dart';
import '../../domain/entities/security_code_entity.dart';
import '../../domain/repositories/tarjeta_repository.dart';
import '../datasources/tarjeta_remote_data_source.dart';

class TarjetaRepositoryImpl implements TarjetaRepository {
  final TarjetaRemoteDataSource remoteDataSource;

  const TarjetaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ConvenioEntity>>> getConvenios() async {
    final convenios = await remoteDataSource.getConvenios();
    return Right(convenios);
  }

  @override
  Future<Either<Failure, SecurityCodeEntity>> generateSecurityCode(
    String convenioId,
  ) async {
    final code = await remoteDataSource.generateSecurityCode(convenioId);
    return Right(code);
  }

  @override
  Future<Either<Failure, void>> simulateUsoEnCaja(String code) async {
    await remoteDataSource.simulateUsoEnCaja(code);
    return const Right(null);
  }
}
