import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.chat,
    required super.content,
    required super.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chat: ChatModel.fromJson(json['chat'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': (sender as UserModel).toJson(),
      'chat': (chat as ChatModel).toJson(),
      'content': content,
      'type': type,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      sender: UserModel.fromEntity(message.sender),
      chat: ChatModel.fromEntity(message.chat),
      content: message.content,
      type: message.type,
    );
  }
}
