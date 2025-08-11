import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class GetChats extends Usecase<List<Chat>, String> {
  final ChattingRepository repository;

  GetChats({required this.repository});
  @override
  Future<Either<Failure, List<Chat>>> call(String id) {
    return repository.getChats(id);
  }
}

class GetParams {}
