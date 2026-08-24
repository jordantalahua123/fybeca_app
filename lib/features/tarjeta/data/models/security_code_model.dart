import '../../domain/entities/security_code_entity.dart';

class SecurityCodeModel extends SecurityCodeEntity {
  const SecurityCodeModel({
    required super.convenioId,
    required super.code,
    required super.expiresAt,
  });
}
