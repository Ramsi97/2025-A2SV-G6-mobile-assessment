class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class UnauthorizedException implements Exception {}
