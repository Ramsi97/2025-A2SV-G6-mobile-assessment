import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:chatting_app/features/chatting/domain/usecases/get_chats.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for ChattingRepository
class MockChattingRepository extends Mock implements ChattingRepository {}

void main() {
  late GetChats getChats;
  late MockChattingRepository mockRepository;

  setUp(() {
    mockRepository = MockChattingRepository();
    getChats = GetChats(repository: mockRepository);
  });

  group('GetChats UseCase', () {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    test('should return list of chats when successful', () async {
      // arrange
      const currentUserId = 'u1';
      final chatList = [
        Chat(id: '1', user1: user1, user2: user2),
        Chat(id: '2', user1: user2, user2: user1),
      ];
      when(
        () => mockRepository.getChats(currentUserId),
      ).thenAnswer((_) async => Right(chatList));

      // act
      final result = await getChats(currentUserId);

      // assert
      expect(result, Right(chatList));
      verify(() => mockRepository.getChats(currentUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      const currentUserId = 'u1';
      final failure = ServerFailure('Error fetching chats');
      when(
        () => mockRepository.getChats(currentUserId),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await getChats(currentUserId);

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getChats(currentUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
