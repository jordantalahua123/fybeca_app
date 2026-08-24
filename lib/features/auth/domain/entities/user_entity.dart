import 'package:equatable/equatable.dart';

enum AuthProvider { email, google, microsoft }

/// Empleado autenticado con su correo corporativo (o una cuenta federada de
/// Google/Microsoft asociada a Fybeca).
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final AuthProvider provider;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
  });

  @override
  List<Object?> get props => [id, name, email, provider];
}
