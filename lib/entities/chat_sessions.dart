import 'package:elephant_chat/entities/chat_message.dart';
import 'package:flutter/material.dart';

class ChatSessions {
  final String userName;
  final String userAvatar;
  final List<ChatMessage> messages;

  ChatSessions(
      {@required this.userName,
      @required this.userAvatar,
      @required this.messages});
}
