import 'package:equatable/equatable.dart';

/// Empleado autenticado. El acceso es corporativo (cédula + clave asignada
/// por Fybeca), no hay autoregistro ni proveedores externos.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String identification;

  const UserEntity({
    required this.id,
    required this.name,
    required this.identification,
  });

  @override
  List<Object?> get props => [id, name, identification];
}
