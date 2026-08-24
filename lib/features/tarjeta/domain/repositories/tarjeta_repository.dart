import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/convenio_entity.dart';
import '../entities/security_code_entity.dart';

abstract class TarjetaRepository {
  Future<Either<Failure, List<ConvenioEntity>>> getConvenios();

  Future<Either<Failure, SecurityCodeEntity>> generateSecurityCode(
    String convenioId,
  );

  Future<Either<Failure, void>> simulateUsoEnCaja(String code);
}
