import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/receive_message.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late ReceiveMessage usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = ReceiveMessage(repository: mockRepository);
  });

  test('should return a stream of messages from the repository', () async {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);
    // Arrange
    final testMessage = Message(
      id: '1',
      chat: chat,
      sender: user1,
      content: 'Hello',
      type: 'text',
    );

    final messageStream = Stream<Message>.fromIterable([testMessage]);
    when(
      () => mockRepository.receiveMessage(),
    ).thenAnswer((_) async => Right(messageStream));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result.isRight(), true);
    result.fold((_) => fail('Expected Right, got Left'), (stream) async {
      final messages = await stream.toList();
      expect(messages.length, 1);
      expect(messages.first.content, 'Hello');
    });

    verify(() => mockRepository.receiveMessage()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // Arrange
    final failure = ServerFailure('Connection error');
    when(
      () => mockRepository.receiveMessage(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.receiveMessage()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
