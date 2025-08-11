import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:chatting_app/features/chatting/domain/usecases/delete_chat.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock class for ChattingRepository
class MockChattingRepository extends Mock implements ChattingRepository {}

void main() {
  late DeleteChat deleteChat;
  late MockChattingRepository mockRepository;

  setUp(() {
    mockRepository = MockChattingRepository();
    deleteChat = DeleteChat(repository: mockRepository);
  });

  group('DeleteChat UseCase', () {
    test('should return Right(void) when deletion is successful', () async {
      // arrange
      when(
        () => mockRepository.deleteChat('123'),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await deleteChat('123');

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.deleteChat('123')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(Failure) when deletion fails', () async {
      // arrange
      final failure = ServerFailure('Unable to delete');
      when(
        () => mockRepository.deleteChat('123'),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await deleteChat('123');

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.deleteChat('123')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
