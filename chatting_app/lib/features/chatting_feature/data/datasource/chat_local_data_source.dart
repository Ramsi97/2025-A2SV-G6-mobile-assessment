

import 'dart:ffi';

import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';

import '../../domain/entities/chat.dart';

abstract class ChatLocalDataSource{
  Future<List<Chat>> getChats();
  Future<Chat> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<Message>> getChatMessage(String chatId);
  Future<void> sendMessage(Message message);
  Future<void> cacheMessages(String chatId, List<Message> message);
  Future<void> cacheChats(List<Chat> chats);
  Future<void> cacheChat(Chat chat);
}