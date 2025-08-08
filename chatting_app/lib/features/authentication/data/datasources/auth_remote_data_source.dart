import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/authentication/data/model/person_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<void> signup(PersonModel person);
  Future<String> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> signup(PersonModel person) async {
    final result = await client.post(
      Uri.parse('https://example.com/signup'),
      headers: {'Content-Type': 'application/json'},
      body: person.toJson(),
    );

    if (result.statusCode == 201) {
      return Future.value();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> login(String username, String password) async {
    final result = await client.post(
      Uri.parse(
        'https://g5-flutter-learning-path-be.onrender.com/api/v2/auth/login',
      ),
      headers: {'Content-Type': 'application/json'},
      body: {'username': username, 'password': password},
    );
    if (result.statusCode == 201) {
      final token = result.body;
      return Future.value(token);
    } else {
      throw ServerException();
    }
  }
}
