import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/send_message.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for ChatRepository
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessage sendMessageUseCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sendMessageUseCase = SendMessage(repository: mockRepository);
  });

  group('SendMessage UseCase', () {

    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);

    final message = Message(
      id: 'm1',
      chat: chat,
      sender: user1,
      content: 'Hello!',
      type: 'text',
    );

    test('should return Message when sending is successful', () async {
      // arrange
      when(
        () => mockRepository.sendMessage(message),
      ).thenAnswer((_) async => Right(null));

      // act
      final result = await sendMessageUseCase(message);

      // assert
      expect(result, Right(null));
      verify(() => mockRepository.sendMessage(message)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      final failure = ServerFailure('Failed to send message');
      when(
        () => mockRepository.sendMessage(message),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await sendMessageUseCase(message);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.sendMessage(message)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
