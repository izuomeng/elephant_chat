// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) {
  return ChatSession(
    id: json['id'] as String,
    userName: json['userName'] as String,
    userAvatar: json['userAvatar'] as String,
    lastMessageType: json['lastMessageType'] as int,
    lastMessageContent: json['lastMessageContent'] as String,
    unreadCnt: json['unreadCnt'] as int,
  );
}

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'lastMessageType': instance.lastMessageType,
      'lastMessageContent': instance.lastMessageContent,
      'unreadCnt': instance.unreadCnt,
    };
