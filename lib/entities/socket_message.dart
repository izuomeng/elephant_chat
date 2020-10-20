import 'package:json_annotation/json_annotation.dart';

part 'socket_message.g.dart';

@JsonSerializable()
class SocketMessage {
  // 1xx: 消息相关的消息
  // 100: 向其他用户发送消息
  // 101: 收到服务端推送来的消息
  final int type;
  final dynamic content;

  SocketMessage(this.type, this.content);

  factory SocketMessage.fromJson(Map<String, dynamic> json) =>
      _$SocketMessageFromJson(json);
  Map<String, dynamic> toJson() => _$SocketMessageToJson(this);
}
