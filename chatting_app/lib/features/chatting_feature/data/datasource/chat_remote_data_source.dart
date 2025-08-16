import 'dart:convert';

import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/chatting_feature/data/model/message_model.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/constant/constant.dart';
import '../model/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Future<ChatModel> initiateChat(String userId);
  Future<void> sendMessage(MessageModel message);
  Stream<Message> receiveMessage();
  Future<List<MessageModel>> getChatMessage(String chatId);

  Future<void> sendReadReceipt({required String messageId, required String readerId}) async {}
  
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final WebSocketChannel channel;

  ChatRemoteDataSourceImpl({required this.client, required this.channel});

  @override
  Future<void> deleteChat(String chatId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/chats/delete/$chatId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'token'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return Future.value(null);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Chat not found');
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      ChatModel result = ChatModel.fromJson(jsonMap);
      return result;
    } else if (response.statusCode == 404) {
      throw NotFoundException('chat with $chatId not found');
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessage(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      return jsonList
          .map((jsonItem) => MessageModel.fromJson(jsonItem))
          .toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException('chat with $chatId not found');
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      return jsonList.map((jsonItem) => ChatModel.fromJson(jsonItem)).toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {

    final response = await client.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token',
      },
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return ChatModel.fromJson(jsonMap);
      } catch (e) {
        throw ServerException();
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw UnauthorizedException();
    } else if (response.statusCode == 404) {
      throw NotFoundException('User with ID $userId not found.');
    } else {
      throw ServerException();
    }
  }


  @override
  Stream<Message> receiveMessage() {
    return channel.stream.map((data) {
      final decoded = jsonDecode(data);
      return Message(
        id: decoded['id'],
        sender: decoded['sender'],
        chat: decoded['chat'],
        timestamp: DateTime.parse(decoded['timestamp']),
        content: decoded['content'],
        type: decoded['type'],
      );
    });
  }


  @override
  Future<void> sendMessage(Message message) {
    final jsonMessage = jsonEncode({
      'id': message.id,
      'sender': message.sender,
      'chat': message.chat,
      'timestamp': message.timestamp.toIso8601String(),
      'content': message.content,
      'type': message.type
    });
    channel.sink.add(jsonMessage);
    return Future.value(null);
  }

  @override
  Future<void> sendReadReceipt({
    required String messageId,
    required String readerId,
  }) async {
    final payload = jsonEncode({
      'type': 'read_receipt', // event type for backend to distinguish
      'messageId': messageId,
      'readerId': readerId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      channel.sink.add(payload);
    } catch (e) {
      rethrow;
    }
  }
}
