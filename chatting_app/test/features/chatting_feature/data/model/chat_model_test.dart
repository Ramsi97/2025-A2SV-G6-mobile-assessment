

import 'package:chatting_app/features/chatting_feature/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting_feature/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {


  group('ChatModel', () {
    final user1 = UserModel(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = UserModel(
        id: 'u2', name: 'Mr. User', email: 'user@gmail.com');
    final chat = ChatModel(id: 'chat1', user1: user1, user2: user2);

    test('fromJson should return a valid ChatModel', () {
      final json = {
        'id': 'chat1',
        'user1': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
        'user2': {'id': 'u2', 'name': 'Mr. User', 'email': 'user@gmail.com'},
      };
      final result = ChatModel.fromJson(json);
      expect(result, chat);
    });

    test('toJson should return a valid JSON map', () {
      final expectedJson = {
        'id': 'chat1',
        'user1': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
        'user2': {'id': 'u2', 'name': 'Mr. User', 'email': 'user@gmail.com'},
      };
      final result = chat.toJson();
      expect(result, expectedJson);
    });
  });
}