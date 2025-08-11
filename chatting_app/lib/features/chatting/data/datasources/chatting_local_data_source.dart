import 'dart:convert';

import 'package:chatting_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/data/model/message_model.dart';

abstract class ChattingLocalDataSource {
  Future<void> cacheChats(List<ChatModel> chats);

  Future<List<ChatModel>> getCachedChats(String userId);

  Future<void> cacheChat(ChatModel chat);

  Future<ChatModel> getCachedChatById(String chatId);

  Future<void> cacheMessages(String chatId, List<MessageModel> messages);

  Future<List<MessageModel>> getCachedMessages(String chatId);

  Future<void> deleteCachedChat(String chatId);
}

class ChattingLocalDataSourceImpl implements ChattingLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _userChatsPrefix = 'USER_CHATS_';
  static const String _chatByIdPrefix = 'CHAT_ID_';
  static const String _messagesPrefix = 'MESSAGES_';

  ChattingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    try {
      final Map<String, List<ChatModel>> userChatsMap = {};

      for (final chat in chats) {
        userChatsMap.putIfAbsent(chat.user1.id, () => []);
        userChatsMap.putIfAbsent(chat.user2.id, () => []);

        userChatsMap[chat.user1.id]!.add(chat);
        userChatsMap[chat.user2.id]!.add(chat);

        // Also cache chat by id separately for quick access
        await cacheChat(chat);
      }

      // Save grouped chats in SharedPreferences as JSON string
      for (final entry in userChatsMap.entries) {
        final jsonList = entry.value
            .map((chat) => json.encode(chat.toJson()))
            .toList();
        final jsonString = json.encode(jsonList);
        final key = _userChatsPrefix + entry.key;
        await sharedPreferences.setString(key, jsonString);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ChatModel>> getCachedChats(String userId) async {
    final key = _userChatsPrefix + userId;
    final jsonString = sharedPreferences.getString(key);

    if (jsonString == null) {
      throw CacheException();
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final chats = jsonList
          .map<ChatModel>(
            (jsonChat) => ChatModel.fromJson(json.decode(jsonChat)),
          )
          .toList();
      return chats;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheChat(ChatModel chat) async {
    final key = _chatByIdPrefix + chat.id;
    final jsonString = json.encode(chat.toJson());
    final success = await sharedPreferences.setString(key, jsonString);
    if (!success) throw CacheException();
  }

  @override
  Future<ChatModel> getCachedChatById(String chatId) async {
    final key = _chatByIdPrefix + chatId;
    final jsonString = sharedPreferences.getString(key);

    if (jsonString == null) {
      throw CacheException();
    }

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return ChatModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    try {
      final key = _messagesPrefix + chatId;
      final jsonList = messages
          .map((message) => json.encode(message.toJson()))
          .toList();
      final jsonString = json.encode(jsonList);
      final success = await sharedPreferences.setString(key, jsonString);
      if (!success) throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final key = _messagesPrefix + chatId;
    final jsonString = sharedPreferences.getString(key);

    if (jsonString == null) {
      throw CacheException();
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final messages = jsonList
          .map<MessageModel>(
            (jsonMessage) => MessageModel.fromJson(json.decode(jsonMessage)),
          )
          .toList();
      return messages;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCachedChat(String chatId) async {
    try {
      final chatKey = _chatByIdPrefix + chatId;
      final messagesKey = _messagesPrefix + chatId;

      // Remove chat
      final chatJson = sharedPreferences.getString(chatKey);
      if (chatJson != null) {
        final chat = ChatModel.fromJson(json.decode(chatJson));
        // Remove chat from user lists
        await _removeChatFromUserChats(chat.user1.id, chatId);
        await _removeChatFromUserChats(chat.user2.id, chatId);
      }

      await sharedPreferences.remove(chatKey);
      await sharedPreferences.remove(messagesKey);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _removeChatFromUserChats(String userId, String chatId) async {
    final key = _userChatsPrefix + userId;
    final jsonString = sharedPreferences.getString(key);
    if (jsonString == null) return;

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final chats = jsonList
          .map<ChatModel>(
            (jsonChat) => ChatModel.fromJson(json.decode(jsonChat)),
          )
          .toList();

      chats.removeWhere((chat) => chat.id == chatId);

      final updatedJsonList = chats
          .map((chat) => json.encode(chat.toJson()))
          .toList();
      final updatedJsonString = json.encode(updatedJsonList);

      await sharedPreferences.setString(key, updatedJsonString);
    } catch (_) {
      throw CacheException();
    }
  }
}
