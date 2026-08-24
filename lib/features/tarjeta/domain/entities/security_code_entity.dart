import 'package:equatable/equatable.dart';

/// Código numérico de un solo uso para validar una compra en caja.
class SecurityCodeEntity extends Equatable {
  final String convenioId;
  final String code;
  final DateTime expiresAt;

  const SecurityCodeEntity({
    required this.convenioId,
    required this.code,
    required this.expiresAt,
  });

  Duration remaining(DateTime now) {
    final diff = expiresAt.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  bool isExpired(DateTime now) => !expiresAt.isAfter(now);

  @override
  List<Object?> get props => [convenioId, code, expiresAt];
}
