
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

import 'chat.dart';


class Message extends Equatable {
  final String id;
  final User sender;
  final Chat chat;
  final String content;
  final String type;

  const Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [id, sender, chat, content, type];
}
