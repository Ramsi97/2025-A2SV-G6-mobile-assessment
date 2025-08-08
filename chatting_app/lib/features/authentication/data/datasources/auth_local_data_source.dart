import 'package:chatting_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String cachedTokenKey = 'CACHED_TOKEN';

abstract class AuthLocalDataSource {
  // Define methods for local data source
  Future<void> cachetoken(String token);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<String> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cachetoken(String token) {
    try {
      // Cache the token in shared preferences
      return sharedPreferences.setString(cachedTokenKey, token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      // Check if the token is cached
      final token = sharedPreferences.getString(cachedTokenKey);
      if (token != null && token.isNotEmpty) {
        return true;
      }
      return false;
    } on CacheException {
      throw CacheException();
    }
  }

  @override
  Future<void> logout() {
    try {
      // Clear the cached token
      sharedPreferences.remove(cachedTokenKey);
      return Future.value();
    } on CacheException {
      throw CacheException();
    }
  }

  @override
  Future<String> getToken() async {
    try {
      // Retrieve the cached token
      final token = sharedPreferences.getString(cachedTokenKey);
      if (token != null && token.isNotEmpty) {
        return Future.value(token);
      } else {
        throw CacheException();
      }
    } on CacheException {
      throw CacheException();
    }
  }
}
