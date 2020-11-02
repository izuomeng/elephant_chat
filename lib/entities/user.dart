import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

// 聊天用户
@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  final String avatar;
  final String name;
  final String phone;

  User(
      {@required this.id,
      @required this.avatar,
      @required this.name,
      @required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserSetting {
  final String hasNotification; // y: 开启通知 n: 关闭通知
  // TODO: more

  const UserSetting({this.hasNotification});
}

// 本机登录用户
class LoginUserNotifier extends ChangeNotifier {
  final String id;
  final String avatar;
  final String name;
  final String phone;
  final UserSetting userSetting;

  LoginUserNotifier(
      {this.userSetting = const UserSetting(hasNotification: 'y'),
      @required this.id,
      @required this.avatar,
      @required this.name,
      @required this.phone});

  set id(String value) {
    id = value;
    notifyListeners();
  }
}
