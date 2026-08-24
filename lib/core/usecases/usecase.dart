import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Contrato que debe cumplir todo caso de uso del dominio.
/// [Success] es lo que retorna en éxito, [Params] lo que recibe como entrada.
abstract class UseCase<Success, Params> {
  Future<Either<Failure, Success>> call(Params params);
}

/// Para casos de uso que no requieren parámetros (ej. logout, get current user).
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
