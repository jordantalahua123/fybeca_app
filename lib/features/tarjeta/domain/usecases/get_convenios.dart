import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/convenio_entity.dart';
import '../repositories/tarjeta_repository.dart';

class GetConvenios implements UseCase<List<ConvenioEntity>, NoParams> {
  final TarjetaRepository repository;

  const GetConvenios(this.repository);

  @override
  Future<Either<Failure, List<ConvenioEntity>>> call(NoParams params) {
    return repository.getConvenios();
  }
}
