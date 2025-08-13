
import 'package:chatting_app/features/chatting_feature/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting_feature/data/model/message_model.dart';
import 'package:chatting_app/features/chatting_feature/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){


  group('MessageModel', () {
    final user = UserModel(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final chat = ChatModel(
      id: 'chat1',
      user1: user,
      user2: UserModel(id: 'u2', name: 'Mr. User', email: 'user@gmail.com'),
    );
    final message = MessageModel(
      id: 'm1',
      sender: user,
      chat: chat,
      content: 'Hello!',
      type: 'text',
      timestamp: DateTime.parse('2025-08-13T12:00:00Z'),
      isRead: false,
    );

    test('fromJson should return a valid MessageModel', () {
      final json = {
        'id': 'm1',
        'sender': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
        'chat': {
          'id': 'chat1',
          'user1': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
          'user2': {'id': 'u2', 'name': 'Mr. User', 'email': 'user@gmail.com'}
        },
        'content': 'Hello!',
        'type': 'text',
        'timestamp': '2025-08-13T12:00:00.000Z',
        'isRead': false
      };
      final result = MessageModel.fromJson(json);
      expect(result, message);
    });

    test('toJson should return a valid JSON map', () {
      final expectedJson = {
        'id': 'm1',
        'sender': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
        'chat': {
          'id': 'chat1',
          'user1': {'id': 'u1', 'name': 'Mr. Cat', 'email': 'cat@gmail.com'},
          'user2': {'id': 'u2', 'name': 'Mr. User', 'email': 'user@gmail.com'}
        },
        'content': 'Hello!',
        'type': 'text',
        'timestamp': '2025-08-13T12:00:00.000Z',
        'isRead': false
      };
      final result = message.toJson();
      expect(result, expectedJson);
    });
  });
}