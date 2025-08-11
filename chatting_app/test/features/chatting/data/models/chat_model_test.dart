import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';

void main() {
  final tUserModel1 = UserModel(
    id: 'u1',
    name: 'Alice',
    email: 'alice@example.com',
  );
  final tUserModel2 = UserModel(
    id: 'u2',
    name: 'Bob',
    email: 'bob@example.com',
  );

  final tChatModel = ChatModel(
    id: 'c1',
    user1: tUserModel1,
    user2: tUserModel2,
  );
  final tChatEntity = Chat(id: 'c1', user1: tUserModel1, user2: tUserModel2);

  final tChatJson = {
    '_id': 'c1',
    'user1': tUserModel1.toJson(),
    'user2': tUserModel2.toJson(),
  };

  group('chatmodel test', () {
    test('should be a subclass of Chat entity', () {
      expect(tChatModel, isA<Chat>());
    });

    test('fromJson should return valid ChatModel', () {
      final result = ChatModel.fromJson(tChatJson);
      expect(result, tChatModel);
    });

    test('toJson should return JSON map containing proper data', () {
      final result = tChatModel.toJson();
      expect(result, tChatJson);
    });

    test('fromEntity should return valid ChatModel', () {
      final result = ChatModel.fromEntity(tChatEntity);
      expect(result, tChatModel);
    });
  });
}
