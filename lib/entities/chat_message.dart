import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatMessage {
  // 1:纯文本 2:图片
  final int type;
  // 不支持富文本，emoji也属于纯文本
  final String text;
  // 一条消息只能有一张图片
  final String image;
  // 发送人
  final String senderId;
  // 接收人
  final String receiverId;
  // 发送时间
  final int time;
  // 是否已读 y: 已读 n: 未读
  final String haveRead;

  ChatMessage(
      {@required this.type,
      @required this.senderId,
      @required this.receiverId,
      @required this.time,
      @required this.haveRead,
      this.text,
      this.image});

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
