import 'package:equatable/equatable.dart';

enum AuthProvider { email, google, microsoft }

/// Usuario autenticado, tal como lo conoce el dominio.
/// No sabe nada de JSON, Spring Boot, Firebase, etc.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final AuthProvider provider;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, name, email, provider, photoUrl];
}
