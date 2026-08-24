/// Excepciones que lanzan las fuentes de datos (data sources).
/// El repositorio las atrapa y las traduce a [Failure] para el dominio.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Ocurrió un error en el servidor.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException([
    this.message = 'No se pudo leer la información local.',
  ]);
}
