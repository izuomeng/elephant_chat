// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFriend _$UserFriendFromJson(Map<String, dynamic> json) {
  return UserFriend(
    id: json['id'] as String,
    fromUser: json['fromUser'] == null
        ? null
        : User.fromJson(json['fromUser'] as Map<String, dynamic>),
    toUser: json['toUser'] == null
        ? null
        : User.fromJson(json['toUser'] as Map<String, dynamic>),
    agreed: json['agreed'] as String,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$UserFriendToJson(UserFriend instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUser?.toJson(),
      'toUser': instance.toUser?.toJson(),
      'agreed': instance.agreed,
      'time': instance.time,
    };
