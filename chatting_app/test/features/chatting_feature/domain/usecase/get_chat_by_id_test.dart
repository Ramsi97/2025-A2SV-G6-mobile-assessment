import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/get_chat_by_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late GetChatById getChatById;

  setUp(() {
    mockChatRepository = MockChatRepository();
    getChatById = GetChatById(repository: mockChatRepository);
  });

  group('Get chat by id use case testing', () {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);

    test('should return Chat when successful', () async {
      const chatId = 'chat1';

      when(
        () => mockChatRepository.getChatById(chatId),
      ).thenAnswer((_) async => Right(chat));

      final result = await getChatById(chatId);

      expect(result, Right(chat));
      verify(() => mockChatRepository.getChatById(chatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return Failure when repository fails', () async {
      const chatId = 'chat1';
      final failure = ServerFailure('Error fetching chat');

      when(
        () => mockChatRepository.getChatById(chatId),
      ).thenAnswer((_) async => Left(failure));

      final result = await getChatById(chatId);

      expect(result, Left(failure));
      verify(() => mockChatRepository.getChatById(chatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });
  });
}
