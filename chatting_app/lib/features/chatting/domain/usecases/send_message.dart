import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessage extends Usecase<void, SendMessageParams> {
  final ChattingRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) {
    return repository.sendMessage(params.chatId, params.message);
  }
}

class SendMessageParams {
  final String chatId;
  final Message message;

  SendMessageParams(this.chatId, this.message);
}
