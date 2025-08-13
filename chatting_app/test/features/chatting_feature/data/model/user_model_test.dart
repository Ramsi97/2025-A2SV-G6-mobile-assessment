

import 'package:chatting_app/features/chatting_feature/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('UserModel', () {
    final user = UserModel(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');

    test('fromJson should return a valid UserModel', () {
      final json = {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'};
      final result = UserModel.fromJson(json);
      expect(result, user);
    });

    test('toJson should return a valid JSON map', () {
      final expectedJson = {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'};
      final result = user.toJson();
      expect(result, expectedJson);
    });
  });
}