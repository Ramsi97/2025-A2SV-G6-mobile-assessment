
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

import 'chat.dart';


class Message extends Equatable {
  final String id;
  final User sender;
  final Chat chat;
  final DateTime timestamp;
  final String content;
  final String type;
  final bool isRead;

  const Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.timestamp,
    required this.content,
    required this.type,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, sender, chat, timestamp, content, type, isRead];
}
