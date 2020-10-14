import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,
                size: 24,
              ),
              label: '消息',
              activeIcon: Icon(
                Icons.chat_bubble_outline,
                color: primaryColor,
                size: 24,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.insert_photo,
                size: 24,
              ),
              label: '动态',
              activeIcon: Icon(
                Icons.insert_photo,
                color: primaryColor,
                size: 24,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 24,
              ),
              label: '我的',
              activeIcon: Icon(
                Icons.settings,
                color: primaryColor,
                size: 24,
              )),
        ]),
      ),
      body: ChatList(),
    );
  }
}
