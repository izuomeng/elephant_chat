// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    id: json['id'] as String,
    type: json['type'] as int,
    sender: json['sender'] == null
        ? null
        : User.fromJson(json['sender'] as Map<String, dynamic>),
    receiverId: json['receiverId'] as String,
    time: json['time'] as int,
    haveRead: json['haveRead'] as String,
    text: json['text'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'text': instance.text,
      'image': instance.image,
      'sender': instance.sender?.toJson(),
      'receiverId': instance.receiverId,
      'time': instance.time,
      'haveRead': instance.haveRead,
    };
