import '../../domain/entities/user_entity.dart';

/// Representación de datos del usuario (JSON <-> objeto). Cuando se conecte
/// el backend Spring Boot, aquí van fromJson/toJson; el resto de la app
/// sigue trabajando con UserEntity sin enterarse del cambio.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.provider,
    super.photoUrl,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      provider: entity.provider,
      photoUrl: entity.photoUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      provider: AuthProvider.values.byName(json['provider'] as String),
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'provider': provider.name,
      'photoUrl': photoUrl,
    };
  }
}
