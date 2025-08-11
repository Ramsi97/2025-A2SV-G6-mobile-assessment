import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChattingRepository {
  Future<Either<Failure, void>> deleteChat(String id);
  Future<Either<Failure, List<Chat>>> getChats(String id);
  Future<Either<Failure, Chat>> getChatById(String id);
  Future<Either<Failure, Chat>> initChat(String id);
  Future<Either<Failure, List<Message>>> getMessage(String id);
  Future<Either<Failure, void>> sendMessage(String id, Message message);
  Stream<Message> receiveMessage(String id);
}
