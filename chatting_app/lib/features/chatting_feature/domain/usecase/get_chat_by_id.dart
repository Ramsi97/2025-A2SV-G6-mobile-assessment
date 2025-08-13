import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatById extends Usecase<Chat, String> {
  final ChatRepository repository;

  GetChatById({required this.repository});

  @override
  Future<Either<Failure, Chat>> call(String chatId) {
    return repository.getChatById(chatId);
  }
}
