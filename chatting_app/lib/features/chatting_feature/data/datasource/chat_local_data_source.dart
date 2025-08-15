import 'package:chatting_app/features/chatting_feature/data/model/message_model.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../model/chat_model.dart';
import '../model/user_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<MessageModel>> getChatMessage(String chatId);
  Future<void> sendMessage(MessageModel message);
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<void> cacheChats(List<ChatModel> chatModels);
  Future<void> cacheChat(ChatModel chatModel);
  Future<void> markMessageAsRead(String messageId) async {}
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<ChatModel> chatBox;
  final Box<MessageModel> messageBox;
  final Box<UserModel> userBox;

  ChatLocalDataSourceImpl({
    required this.chatBox,
    required this.messageBox,
    required this.userBox,
  });

  @override
  Future<void> cacheChat(ChatModel chatModel) async {
    try {
      await chatBox.put(chatModel.id, chatModel);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheChats(List<ChatModel> chatModels) async {
    try {
      final entries = {for (var chat in chatModels) chat.id: chat};
      await chatBox.putAll(entries);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    try {
      final entries = {for (var message in messages) message.id: message};
      await messageBox.putAll(entries);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      await chatBox.delete(chatId);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    try {
      final chat = chatBox.get(chatId);
      if (chat != null) {
        return chat;
      }
      throw CacheException();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessage(String chatId) async {
    try {
      final messages = messageBox.values.toList();
      return messages;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      return chatBox.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    try {
      await messageBox.put(message.id, message);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    try {
      final message = messageBox.get(messageId);
      if (message != null) {
        final updatedMessage = MessageModel(
          id: message.id,
          sender: message.sender,
          chat: message.chat,
          timestamp: message.timestamp,
          content: message.content,
          type: message.type,
          isRead: true,
        );
        await messageBox.put(updatedMessage.id, updatedMessage);
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
