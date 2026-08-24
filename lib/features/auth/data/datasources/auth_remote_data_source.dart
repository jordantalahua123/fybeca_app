import '../models/user_model.dart';

/// Contrato de la fuente de datos remota. La implementación actual es un
/// mock en memoria (sin red, sin backend) para poder construir y demostrar
/// todo el front. El día de mañana se agrega `AuthApiDataSource` (Spring
/// Boot vía Dio/http) implementando esta misma interfaz, sin tocar el
/// repositorio, los casos de uso ni la UI.
abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithIdentification({
    required String identification,
    required String password,
  });
}

class AuthMockDataSource implements AuthRemoteDataSource {
  static const demoIdentification = '1720123456';
  static const demoPassword = 'Fybeca2026';

  final Map<String, ({String password, String name})> _employees = {
    demoIdentification: (password: demoPassword, name: 'Miguel Imba'),
  };

  @override
  Future<UserModel> loginWithIdentification({
    required String identification,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final employee = _employees[identification.trim()];
    if (employee == null) {
      throw const AuthMockException(
        'No encontramos una cuenta con esa cédula.',
      );
    }
    if (employee.password != password) {
      throw const AuthMockException('La contraseña es incorrecta.');
    }

    return UserModel(
      id: identification.trim(),
      name: employee.name,
      identification: identification.trim(),
    );
  }
}

/// Excepción específica del mock; el repositorio la mapea a [AuthFailure]
/// igual que mapearía una excepción real de autenticación.
class AuthMockException implements Exception {
  final String message;
  const AuthMockException(this.message);
}
