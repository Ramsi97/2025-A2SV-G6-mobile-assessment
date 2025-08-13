import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ReceiveMessage extends Usecase<Stream<Message>, NoParams> {
  final ChatRepository repository;

  ReceiveMessage({required this.repository});

  @override
  Future<Either<Failure, Stream<Message>>> call(NoParams params) {
    return repository.receiveMessage();
  }
}
