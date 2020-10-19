import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  final String avatar;
  final String name;

  User({@required this.id, @required this.avatar, @required this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserSetting {
  final String hasNotification; // y: 开启通知 n: 关闭通知
  // TODO: more

  const UserSetting({this.hasNotification});
}

class LoginUserNotifier extends ChangeNotifier {
  final String id;
  final String avatar;
  final String name;
  final UserSetting userSetting;

  LoginUserNotifier({
    this.userSetting = const UserSetting(hasNotification: 'y'),
    @required this.id,
    @required this.avatar,
    @required this.name,
  });

  set id(String value) {
    id = value;
    notifyListeners();
  }
}
