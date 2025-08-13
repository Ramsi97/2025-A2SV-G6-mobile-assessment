import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/delete_chat.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late DeleteChat deleteChat;

  setUp(() {
    mockChatRepository = MockChatRepository();
    deleteChat = DeleteChat(repository: mockChatRepository);
  });

  group('DeleteChat use case test', () {
    test('should return Right(void) when deletion is successful', () async {
      // arrange
      when(
        () => mockChatRepository.deleteChat('123'),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await deleteChat('123');

      // assert
      expect(result, const Right(null));
      verify(() => mockChatRepository.deleteChat('123')).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return Left(Failure) when deletion fails', () async {
      // arrange
      final failure = ServerFailure('Unable to delete');
      when(
        () => mockChatRepository.deleteChat('123'),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await deleteChat('123');

      // assert
      expect(result, Left(failure));
      verify(() => mockChatRepository.deleteChat('123')).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });
  });
}
