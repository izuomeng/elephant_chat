import 'package:elephant_chat/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_friend.g.dart';

// 聊天用户
@JsonSerializable(explicitToJson: true)
class UserFriend {
  final String id;
  final User fromUser;
  final User toUser;
  final String agreed; // y: true, n: false
  final int time;

  UserFriend(
      {@required this.id,
      @required this.fromUser,
      @required this.toUser,
      @required this.agreed,
      @required this.time});

  factory UserFriend.fromJson(Map<String, dynamic> json) =>
      _$UserFriendFromJson(json);
  Map<String, dynamic> toJson() => _$UserFriendToJson(this);
}
