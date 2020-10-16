// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    type: json['type'] as int,
    senderId: json['senderId'] as String,
    receiverId: json['receiverId'] as String,
    time: json['time'] as int,
    haveRead: json['haveRead'] as String,
    text: json['text'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'image': instance.image,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'time': instance.time,
      'haveRead': instance.haveRead,
    };
