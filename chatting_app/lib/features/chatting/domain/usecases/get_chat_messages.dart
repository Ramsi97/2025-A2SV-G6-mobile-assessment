import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatMessages extends Usecase<List<Message>, String> {
  final ChattingRepository repository;

  GetChatMessages({required this.repository});

  @override
  Future<Either<Failure, List<Message>>> call(String id) {
    return repository.getMessage(id);
  }
}
