import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/data/model/message_model.dart';
import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';

void main() {
  final tUserModel = UserModel(
    id: 'u1',
    name: 'Alice',
    email: 'alice@example.com',
  );
  final tUserEntity = User(id: 'u1', name: 'Alice', email: 'alice@example.com');

  final tChatModel = ChatModel(id: 'c1', user1: tUserModel, user2: tUserModel);
  final tChatEntity = Chat(id: 'c1', user1: tUserModel, user2: tUserModel);

  final tMessageModel = MessageModel(
    id: 'm1',
    sender: tUserModel,
    chat: tChatModel,
    content: 'Hi there',
    type: 'text',
  );

  final tMessageEntity = Message(
    id: 'm1',
    sender: tUserEntity,
    chat: tChatEntity,
    content: 'Hi there',
    type: 'text',
  );

  final tMessageJson = {
    '_id': 'm1',
    'sender': tUserModel.toJson(),
    'chat': tChatModel.toJson(),
    'content': 'Hi there',
    'type': 'text',
  };

  group('Message Model Test', () {
    test('should be a subclass of Message entity', () {
      expect(tMessageModel, isA<Message>());
    });

    test('fromJson should return valid MessageModel', () {
      final result = MessageModel.fromJson(tMessageJson);
      expect(result, tMessageModel);
    });

    test('toJson should return JSON map containing proper data', () {
      final result = tMessageModel.toJson();
      expect(result, tMessageJson);
    });

    test('fromEntity should return valid MessageModel', () {
      final result = MessageModel.fromEntity(tMessageEntity);
      expect(result, tMessageModel);
    });
  });
}
