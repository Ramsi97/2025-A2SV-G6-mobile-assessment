
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChat();
  Future<Either<Failure, void>> deleteChat(String chatId);
  Future<Either<Failure, Chat>> getChatById(String chatId);
  Future<Either<Failure, Chat>> initiateChat(String userId);
  Future<Either<Failure, List<Message>>> getChatMessage(String chatId);
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, Stream<Message>>> receiveMessage();

}