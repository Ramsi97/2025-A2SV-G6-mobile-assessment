import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:chatting_app/features/chatting/domain/usecases/get_chat_messages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for ChattingRepository
class MockChattingRepository extends Mock implements ChattingRepository {}

void main() {
  late GetChatMessages getChatMessages;
  late MockChattingRepository mockRepository;

  setUp(() {
    mockRepository = MockChattingRepository();
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
          content: 'Hello',
          type: 'text',
        ),
        Message(
          id: 'm2',
          sender: user2,
          chat: chat,
          content: 'Hi there!',
          type: 'text',
        ),
      ];
      when(
        () => mockRepository.getMessage(chatId),
      ).thenAnswer((_) async => Right(messageList));

      // act
      final result = await getChatMessages(chatId);

      // assert
      expect(result, Right(messageList));
      verify(() => mockRepository.getMessage(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      const chatId = 'chat1';
      final failure = ServerFailure('Error fetching messages');
      when(
        () => mockRepository.getMessage(chatId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await getChatMessages(chatId);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getMessage(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
