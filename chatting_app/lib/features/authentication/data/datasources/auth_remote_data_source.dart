import 'dart:convert';
import 'dart:io';

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
    try {
      dynamic p = person.toJson();
      final response = await client.post(
        Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/auth/register',
        ),

        body: json.encode(person.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
      );

      if (response.statusCode != 201) {
        throw ServerException();
      }
    } on SocketException {
      throw ServerException();
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      dynamic test = jsonEncode({'email': email, 'password': password});
      final response = await client.post(
        Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/auth/login',
        ),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        try {
          final responseBody = jsonDecode(response.body);
          final token = responseBody['data']['access_token'] as String;
          return token;
        } catch (e) {
          throw FormatException('Failed to parse response: ${e.toString()}');
        }
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on FormatException catch (e) {
      // Re-throw with more context
      throw FormatException('Invalid response format: ${e.message}');
    } catch (e) {
      throw ServerException();
    }
  }
}
