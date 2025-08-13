

import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';

abstract class ChatRemoteDataSource{
  Future<List<Chat>> getChats();
  Future<Chat> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Future<Chat> initiateChat(String userId);
  Future<void> sendMessage(Message message);
  Stream<Message> receiveMessage();
  Future<List<Message>> getChatMessage(String chatId);

}