import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/widgets/chat_list.dart';
import 'package:elephant_chat/widgets/fancy_tab_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final List<TabItem> tabList = [
    TabItem(icon: Icons.chat_bubble_outline, title: '消息'),
    TabItem(icon: Icons.insert_photo, title: '动态'),
    TabItem(icon: Icons.settings, title: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FancyTabBar(
        tablist: tabList,
      ),
      body: ChatList(),
    );
  }
}
