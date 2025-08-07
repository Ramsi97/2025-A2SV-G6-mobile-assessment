import 'package:chatting_app/features/authentication/data/model/person_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signup(PersonModel person);
  Future<String> login(String username, String password);
  Future<void> logout();
}
