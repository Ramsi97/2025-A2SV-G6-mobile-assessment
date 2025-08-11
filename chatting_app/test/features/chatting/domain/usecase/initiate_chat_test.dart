import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:chatting_app/features/chatting/domain/usecases/initiate_chat.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for ChattingRepository
class MockChattingRepository extends Mock implements ChattingRepository {}

void main() {
  late InitiateChat initiateChat;
  late MockChattingRepository mockRepository;

  setUp(() {
    mockRepository = MockChattingRepository();
    initiateChat = InitiateChat(repository: mockRepository);
  });

  group('InitiateChat UseCase', () {
    // Fake users
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    // Fake chat
    final chat = Chat(id: 'chat1', user1: user1, user2: user2);

    test('should return Chat when successful', () async {
      // arrange
      const targetUserId = 'u2';
      when(
        () => mockRepository.initChat(targetUserId),
      ).thenAnswer((_) async => Right(chat));

      // act
      final result = await initiateChat(targetUserId);

      // assert
      expect(result, Right(chat));
      verify(() => mockRepository.initChat(targetUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      const targetUserId = 'u2';
      final failure = ServerFailure('Failed to initiate chat');
      when(
        () => mockRepository.initChat(targetUserId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await initiateChat(targetUserId);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.initChat(targetUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
