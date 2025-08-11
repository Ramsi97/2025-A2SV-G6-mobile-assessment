import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class InitiateChat extends Usecase<Chat, String> {
  final ChattingRepository repository;

  InitiateChat({required this.repository});
  @override
  Future<Either<Failure, Chat>> call(String id) {
    return repository.initChat(id);
  }
}
