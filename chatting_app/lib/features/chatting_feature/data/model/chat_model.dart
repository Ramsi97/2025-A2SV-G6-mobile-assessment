import 'package:chatting_app/features/chatting_feature/data/model/user_model.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';


class ChatModel extends Chat {
  const ChatModel({required super.id, required super.user1, required super.user2});

  // Factory constructor to create ChatModel from JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1': user1 is UserModel
          ? (user1 as UserModel).toJson()
          : UserModel(
              id: user1.id,
              name: user1.name,
              email: user1.email,
            ).toJson(),
      'user2': user2 is UserModel
          ? (user2 as UserModel).toJson()
          : UserModel(
              id: user2.id,
              name: user2.name,
              email: user2.email,
            ).toJson(),
    };
  }

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      user1: UserModel.fromEntity(chat.user1),
      user2: UserModel.fromEntity(chat.user2),
    );
  }

  Chat toEntity() {
    return Chat(
      id: id,
      user1: (user1 as UserModel).toEntity(),
      user2: (user2 as UserModel).toEntity(),
    );
  }

}
