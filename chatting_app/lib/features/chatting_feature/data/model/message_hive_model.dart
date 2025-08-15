import 'package:hive/hive.dart';
import '../../domain/entities/chat.dart';
import 'user_hive_model.dart';
import '../../domain/entities/message.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: 2)
class MessageHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Chat chat;

  @HiveField(2)
  final UserHiveModel sender;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final bool isRead;

  MessageHiveModel({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });

  factory MessageHiveModel.fromEntity(Message message) {
    return MessageHiveModel(
      id: message.id,
      chat: message.chat,
      sender: UserHiveModel.fromEntity(message.sender),
      content: message.content,
      timestamp: message.timestamp,
      type: message.type,
      isRead: message.isRead,
    );
  }

  Message toEntity() => Message(
    id: id,
    chat: chat,
    sender: sender.toEntity(),
    content: content,
    timestamp: timestamp,
    type: type,
    isRead: isRead,
  );
}
