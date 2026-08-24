import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Contrato de la fuente de datos remota. La implementación actual es un
/// mock en memoria (sin red, sin backend) para poder construir y demostrar
/// todo el front. El día de mañana se agrega `AuthApiDataSource` (Spring
/// Boot vía Dio/http), `AuthGoogleDataSource` (google_sign_in) y
/// `AuthMicrosoftDataSource` (MSAL/oauth) implementando esta misma interfaz,
/// sin tocar el repositorio, los casos de uso ni la UI.
abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailAndPassword({required String email, required String password});

  Future<UserModel> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithMicrosoft();
}

class AuthMockDataSource implements AuthRemoteDataSource {
  // "Base de datos" en memoria, solo para simular un flujo real sin backend.
  final Map<String, String> _registeredUsers = {
    'demo@fybeca.com': '123456',
  };

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final storedPassword = _registeredUsers[email.trim().toLowerCase()];
    if (storedPassword == null) {
      throw const AuthMockException('No existe una cuenta con ese correo.');
    }
    if (storedPassword != password) {
      throw const AuthMockException('La contraseña es incorrecta.');
    }

    return UserModel(
      id: email.trim().toLowerCase(),
      name: email.split('@').first,
      email: email.trim().toLowerCase(),
      provider: AuthProvider.email,
    );
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.trim().toLowerCase();
    if (_registeredUsers.containsKey(normalizedEmail)) {
      throw const AuthMockException('Ya existe una cuenta registrada con ese correo.');
    }

    _registeredUsers[normalizedEmail] = password;

    return UserModel(
      id: normalizedEmail,
      name: name.trim(),
      email: normalizedEmail,
      provider: AuthProvider.email,
    );
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const UserModel(
      id: 'google-demo-user',
      name: 'Usuario Google',
      email: 'usuario.demo@gmail.com',
      provider: AuthProvider.google,
    );
  }

  @override
  Future<UserModel> loginWithMicrosoft() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const UserModel(
      id: 'microsoft-demo-user',
      name: 'Usuario Microsoft',
      email: 'usuario.demo@outlook.com',
      provider: AuthProvider.microsoft,
    );
  }
}

/// Excepción específica del mock; el repositorio la mapea a [AuthFailure]
/// igual que mapearía una excepción real de autenticación.
class AuthMockException implements Exception {
  final String message;
  const AuthMockException(this.message);
}
