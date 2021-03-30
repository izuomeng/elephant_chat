import 'dart:convert';
import 'dart:math';

import 'package:elephant_chat/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EleUtils {
  static ListMap jsMap<T, P>(List<T> list) {
    return ListMap<T, P>(list);
  }

  static String generateId() =>
      int.parse(Random().nextDouble().toString().substring(2))
          .toRadixString(36);

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  static Future<User> getLoginUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJson = prefs.getString('user');
      if (userJson.isNotEmpty) {
        return User.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setLoginUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(user);
    await prefs.setString('user', userJson);
  }

  static Future<void> clearLoginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', '');
  }
}

class ListMap<T, P> {
  final List<T> list;

  ListMap(this.list);

  List<P> map(P callback(T item, int index)) {
    return list
        .asMap()
        .map((key, value) => MapEntry(
            key,
            callback(
              value,
              key,
            )))
        .values
        .toList();
  }
}
