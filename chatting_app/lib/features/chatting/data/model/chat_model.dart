import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';

// Wrapper for the whole response

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.user1,
    required super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] as String,
      user1: UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: UserModel.fromJson(json['user2'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': (user1 as UserModel).toJson(),
      'user2': (user2 as UserModel).toJson(),
    };
  }

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      user1: UserModel.fromEntity(chat.user1),
      user2: UserModel.fromEntity(chat.user2),
    );
  }
}
