import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteChat extends Usecase<void, String> {
  final ChatRepository repository;

  DeleteChat({required this.repository});

  @override
  Future<Either<Failure, void>> call(String chatId) {
    return repository.deleteChat(chatId);
  }
}
