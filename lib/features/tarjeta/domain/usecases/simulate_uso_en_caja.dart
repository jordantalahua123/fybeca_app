import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/tarjeta_repository.dart';

class SimulateUsoEnCaja implements UseCase<void, String> {
  final TarjetaRepository repository;

  const SimulateUsoEnCaja(this.repository);

  @override
  Future<Either<Failure, void>> call(String code) {
    return repository.simulateUsoEnCaja(code);
  }
}
