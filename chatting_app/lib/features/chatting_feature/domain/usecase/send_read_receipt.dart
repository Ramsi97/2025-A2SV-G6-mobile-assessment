import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SendReadReceipt extends Usecase<void, SendReadReceiptParam> {
  final ChatRepository repository;

  SendReadReceipt({required this.repository});
  @override
  Future<Either<Failure, void>> call(SendReadReceiptParam param) {
    return repository.sendReadReceipt(param.messageId, param.readerId);
  }
}

class SendReadReceiptParam extends Equatable {
  final String messageId;
  final String readerId;
  const SendReadReceiptParam({required this.messageId, required this.readerId});

  @override
  List<Object?> get props => [messageId, readerId];
}
