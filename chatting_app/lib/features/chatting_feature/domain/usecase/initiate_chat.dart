import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/chat.dart';

class InitiateChat extends Usecase<Chat, String> {
  final ChatRepository repository;

  InitiateChat({required this.repository});

  @override
  Future<Either<Failure, Chat>> call(String userId) {
    return repository.initiateChat(userId);
  }
}
