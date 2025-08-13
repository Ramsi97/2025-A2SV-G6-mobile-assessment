import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatMessages extends Usecase<List<Message>, String> {
  final ChatRepository repository;

  GetChatMessages({required this.repository});

  @override
  Future<Either<Failure, List<Message>>> call(String chatId) {
    return repository.getChatMessage(chatId);
  }
}
