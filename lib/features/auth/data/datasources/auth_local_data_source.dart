import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Guarda la sesión actual. Hoy vive en memoria (se pierde al cerrar la app);
/// cuando se conecte el backend, esta misma interfaz se implementa con
/// flutter_secure_storage para persistir el JWT sin cambiar el repositorio.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<UserModel> getCachedUser();

  Future<void> clearUser();
}

class AuthInMemoryDataSource implements AuthLocalDataSource {
  UserModel? _cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    _cachedUser = user;
  }

  @override
  Future<UserModel> getCachedUser() async {
    final user = _cachedUser;
    if (user == null) {
      throw const CacheException('No hay una sesión activa.');
    }
    return user;
  }

  @override
  Future<void> clearUser() async {
    _cachedUser = null;
  }
}
