import 'package:elephant_chat/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_session.g.dart';

@JsonSerializable()
class ChatSession {
  final String userName;
  final String userAvatar;
  final List<ChatMessage> messages;

  ChatSession(
      {@required this.userName,
      @required this.userAvatar,
      @required this.messages});

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}
