import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Contrato de la fuente de datos remota. Mock en memoria (sin red, sin
/// backend) para mostrar el mockup completo de los 3 flujos de acceso. El
/// día de mañana se agrega `AuthApiDataSource` (Spring Boot),
/// `AuthGoogleDataSource` (google_sign_in) y `AuthMicrosoftDataSource`
/// (MSAL/oauth) implementando esta misma interfaz, sin tocar el resto de
/// capas.
abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithMicrosoft();
}

class AuthMockDataSource implements AuthRemoteDataSource {
  /// Cuenta que aparece en el selector de cuentas de Google/Microsoft del
  /// mockup — es la misma identidad demo en toda la app.
  static const demoName = 'Miguel Imba';
  static const demoEmail = 'miguel.imba@fybeca.com';

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.trim().toLowerCase();
    final localPart = normalizedEmail.split('@').first;
    final name = localPart
        .split(RegExp(r'[._-]'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');

    return UserModel(
      id: normalizedEmail,
      name: name.isEmpty ? normalizedEmail : name,
      email: normalizedEmail,
      provider: AuthProvider.email,
    );
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const UserModel(
      id: 'google-$demoEmail',
      name: demoName,
      email: demoEmail,
      provider: AuthProvider.google,
    );
  }

  @override
  Future<UserModel> loginWithMicrosoft() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const UserModel(
      id: 'microsoft-$demoEmail',
      name: demoName,
      email: demoEmail,
      provider: AuthProvider.microsoft,
    );
  }
}
