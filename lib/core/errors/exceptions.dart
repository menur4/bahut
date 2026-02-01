/// Exceptions pour la couche data

/// Exception serveur (API)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

/// Exception réseau
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Pas de connexion internet'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception d'authentification
class AuthException implements Exception {
  final String message;
  final bool isTokenExpired;

  const AuthException({required this.message, this.isTokenExpired = false});

  @override
  String toString() => 'AuthException: $message';
}

/// Exception de cache
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Erreur de cache'});

  @override
  String toString() => 'CacheException: $message';
}
