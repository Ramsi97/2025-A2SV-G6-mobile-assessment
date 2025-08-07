import 'package:chatting_app/features/authentication/data/model/person_model.dart';

abstract class AuthLocalDataSource {
  // Define methods for local data source
  Future<void> cachetoken(String token);
  Future<String> getToken();
  Future<void> cleartoken();
}
