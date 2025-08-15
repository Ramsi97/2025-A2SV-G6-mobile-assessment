

import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chatting_feature/domain/usecase/send_read_receipt.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository{}

void main(){

  late MockChatRepository mockChatRepository;
  late SendReadReceipt sendReadReceipt;

  setUp((){
    mockChatRepository = MockChatRepository();
    sendReadReceipt = SendReadReceipt(repository: mockChatRepository);
  });

  group('SendReadReceipt use case Testing', (){

    test('should return Right(void) when sendReadReceipt is successful', () async {
      // arrange
      when(
            () => mockChatRepository.sendReadReceipt('123', 'user1'),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await sendReadReceipt(SendReadReceiptParam(messageId: '123', readerId: 'user1'));

      // assert
      expect(result, const Right(null));
      verify(() => mockChatRepository.sendReadReceipt('123', 'user1')).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return Left(Failure) when SendReadReciept fails', () async {
      // arrange
      final failure = ServerFailure('Unable to delete');
      when(
            () => mockChatRepository.sendReadReceipt('123', 'user1'),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await sendReadReceipt(SendReadReceiptParam(messageId: '123', readerId: 'user1'));

      // assert
      expect(result, Left(failure));
      verify(() => mockChatRepository.sendReadReceipt('123', 'user1')).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });
  });
}