import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChat extends Usecase<List<Chat>, NoParams> {
  final ChatRepository repository;

  GetChat({required this.repository});

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) {
    return repository.getChat();
  }
}
