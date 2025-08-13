import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/get_chat_messages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for ChattingRepository
class MockChatRepository extends Mock implements  ChatRepository{}

void main() {
  late GetChatMessages getChatMessages;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    getChatMessages = GetChatMessages(repository: mockRepository);
  });

  group('GetChatMessages UseCase', () {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);

    test('should return list of messages when successful', () async {
      // arrange
      const chatId = 'chat1';
      final messageList = [
        Message(
          id: 'm1',
          sender: user1,
          chat: chat,
          timestamp: DateTime.now(),
          content: 'Hello',
          type: 'text',
        ),
        Message(
          id: 'm2',
          sender: user2,
          chat: chat,
          timestamp: DateTime.now(),
          content: 'Hi there!',
          type: 'text',
        ),
      ];
      when(
            () => mockRepository.getChatMessage(chatId),
      ).thenAnswer((_) async => Right(messageList));

      // act
      final result = await getChatMessages(chatId);

      // assert
      expect(result, Right(messageList));
      verify(() => mockRepository.getChatMessage(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      const chatId = 'chat1';
      final failure = ServerFailure('Error fetching messages');
      when(
            () => mockRepository.getChatMessage(chatId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await getChatMessages(chatId);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getChatMessage(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
