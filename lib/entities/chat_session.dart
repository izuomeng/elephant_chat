import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_session.g.dart';

@JsonSerializable()
class ChatSession {
  final String id;
  final String userName;
  final String userAvatar;
  final int lastMessageType; // 1:文本 2:图片
  final String lastMessageContent;
  final int lastMessageTime;
  final int unreadCnt;

  ChatSession(
      {@required this.id,
      @required this.userName,
      @required this.userAvatar,
      @required this.lastMessageType,
      @required this.lastMessageContent,
      @required this.lastMessageTime,
      @required this.unreadCnt});

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}
