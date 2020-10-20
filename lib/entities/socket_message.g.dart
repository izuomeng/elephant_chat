// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketMessage _$SocketMessageFromJson(Map<String, dynamic> json) {
  return SocketMessage(
    json['type'] as int,
    json['content'],
  );
}

Map<String, dynamic> _$SocketMessageToJson(SocketMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
    };
