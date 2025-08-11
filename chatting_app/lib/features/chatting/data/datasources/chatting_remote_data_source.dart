import 'dart:convert';
import 'package:chatting_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/data/model/message_model.dart';

abstract class ChattingRemoteDataSource {
  Future<void> deleteChat(String id);

  Future<List<ChatModel>> getChats(String userId);

  Future<ChatModel> getChatById(String chatId);

  Future<ChatModel> initChat(String userId);

  Future<List<MessageModel>> getMessages(String chatId);

  Future<void> sendMessage(String chatId, MessageModel message);

  Stream<MessageModel> receiveMessage(String chatId);
}

class ChattingRemoteDataSourceImpl implements ChattingRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChattingRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<void> deleteChat(String id) async {
    final url = Uri.parse('$baseUrl/chats/$id');

    final response = await client.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getChats(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/chats');

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> data = decodedJson['data'];

      return data.map((jsonChat) => ChatModel.fromJson(jsonChat)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    final url = Uri.parse('$baseUrl/chats/$chatId');

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final Map<String, dynamic> data = decodedJson['data'];

      return ChatModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initChat(String userId) async {
    final url = Uri.parse('$baseUrl/chats/initiate');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final Map<String, dynamic> data = decodedJson['data'];

      return ChatModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/chats/$chatId/messages');

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> data = decodedJson['data'];

      return data.map((jsonMsg) => MessageModel.fromJson(jsonMsg)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Stream<MessageModel> receiveMessage(String chatId) {
    // TODO: implement receiveMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
