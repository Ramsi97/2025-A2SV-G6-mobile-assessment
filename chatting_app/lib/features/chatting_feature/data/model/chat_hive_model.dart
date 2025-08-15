import 'package:hive/hive.dart';
import 'user_hive_model.dart';
import 'message_hive_model.dart';
import '../../domain/entities/chat.dart';

part 'chat_hive_model.g.dart';

@HiveType(typeId: 3)
class ChatHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final UserHiveModel user1;

  @HiveField(2)
  final UserHiveModel user2;


  ChatHiveModel({
    required this.id,
    required this.user1,
    required this.user2,
  });

  factory ChatHiveModel.fromEntity(Chat chat) {
    return ChatHiveModel(
      id: chat.id,
      user1: UserHiveModel.fromEntity(chat.user1),
      user2: UserHiveModel.fromEntity(chat.user2),
    );
  }

  Chat toEntity() {
    return Chat(
      id: id,
      user1: user1.toEntity(),
      user2: user2.toEntity(),
    );
  }
}
