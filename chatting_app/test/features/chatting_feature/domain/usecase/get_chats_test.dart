import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/get_chats.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late GetChat getChat;

  setUp(() {
    mockChatRepository = MockChatRepository();
    getChat = GetChat(repository: mockChatRepository);
  });

  group('GetChat UseCase', () {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);
    final chats = [chat];

    test('should return list of chats when successful', () async {
      // arrange
      when(() => mockChatRepository.getChat())
          .thenAnswer((_) async => Right(chats));

      // act
      final result = await getChat(NoParams());

      // assert
      expect(result, Right(chats));
      verify(() => mockChatRepository.getChat()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      final failure = ServerFailure('Failed to get chats');
      when(() => mockChatRepository.getChat())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await getChat(NoParams());

      // assert
      expect(result, Left(failure));
      verify(() => mockChatRepository.getChat()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });
  });
}
