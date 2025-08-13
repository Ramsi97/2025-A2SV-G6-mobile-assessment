import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/data/model/user_model.dart';
import 'package:chatting_app/features/chatting_feature/data/model/chat_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.chat,
    required super.timestamp,
    required super.content,
    required super.type,
    super.isRead = false,
  });

  // Factory constructor to create MessageModel from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: UserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      timestamp: DateTime.parse(json['timestamp']),
      content: json['content'],
      type: json['type'],
      isRead: json['isRead'] ?? false,
    );
  }

  // Method to convert MessageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender is UserModel ? (sender as UserModel).toJson() : UserModel(id: sender.id, name: sender.name, email: sender.email).toJson(),
      'chat': chat is ChatModel ? (chat as ChatModel).toJson() : ChatModel(id: chat.id, user1: chat.user1, user2: chat.user2).toJson(),
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'type': type,
      'isRead': isRead,
    };
  }
}
