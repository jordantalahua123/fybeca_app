import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/security_code_entity.dart';
import '../repositories/tarjeta_repository.dart';

class GenerateSecurityCode implements UseCase<SecurityCodeEntity, String> {
  final TarjetaRepository repository;

  const GenerateSecurityCode(this.repository);

  @override
  Future<Either<Failure, SecurityCodeEntity>> call(String convenioId) {
    return repository.generateSecurityCode(convenioId);
  }
}
