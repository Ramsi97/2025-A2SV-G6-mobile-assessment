import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteChat extends Usecase<void, String> {
  final ChattingRepository repository;

  DeleteChat({required this.repository});
  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteChat(id);
  }
}
