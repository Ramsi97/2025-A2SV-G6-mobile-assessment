import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessage extends Usecase<void, Message> {
  final ChatRepository repository;

  SendMessage({required this.repository});

  @override
  Future<Either<Failure, void>> call(Message message) {
    return repository.sendMessage(message);
  }
}
