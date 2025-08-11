import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/user.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:chatting_app/features/chatting/domain/usecases/get_chat_by_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockChattingRepository extends Mock implements ChattingRepository {}

void main() {
  late GetChatById getChatById;
  late MockChattingRepository mockRepository;

  setUp(() {
    mockRepository = MockChattingRepository();
    getChatById = GetChatById(repository: mockRepository);
  });

  group('GetChatById UseCase', () {
    final user1 = User(id: 'u1', name: 'Mr. Cat', email: 'cat@gmail.com');
    final user2 = User(id: 'u2', name: 'Mr. User', email: 'user@gmail.com');

    final chat = Chat(id: 'chat1', user1: user1, user2: user2);

    test('should return Chat when successful', () async {
      const chatId = 'chat1';

      when(
        () => mockRepository.getChatById(chatId),
      ).thenAnswer((_) async => Right(chat));

      final result = await getChatById(chatId);

      expect(result, Right(chat));
      verify(() => mockRepository.getChatById(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      const chatId = 'chat1';
      final failure = ServerFailure('Error fetching chat');

      when(
        () => mockRepository.getChatById(chatId),
      ).thenAnswer((_) async => Left(failure));

      final result = await getChatById(chatId);

      expect(result, Left(failure));
      verify(() => mockRepository.getChatById(chatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
