import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';

void main() {
  final tUserModel = UserModel(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
  );
  final tUserEntity = User(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
  );

  final tUserJson = {
    '_id': '123',
    'name': 'John Doe',
    'email': 'john@example.com',
  };

  group('UserModel Test', () {
    test('should be a subclass of User entity', () {
      expect(tUserModel, isA<User>());
    });

    test('fromJson should return valid UserModel', () {
      final result = UserModel.fromJson(tUserJson);
      expect(result, tUserModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tUserModel.toJson();
      expect(result, tUserJson);
    });

    test('fromEntity should return valid UserModel', () {
      final result = UserModel.fromEntity(tUserEntity);
      expect(result, tUserModel);
    });
  });
}
