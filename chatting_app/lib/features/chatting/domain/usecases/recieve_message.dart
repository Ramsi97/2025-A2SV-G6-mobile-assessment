import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/stream_usecase.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class RecieveMessage extends StreamUsecase<Message, String> {
  final ChattingRepository repository;

  RecieveMessage(this.repository);

  @override
  Stream<Message> call(String id) {
    return repository.receiveMessage(id);
  }
}
