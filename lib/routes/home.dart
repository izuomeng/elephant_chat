import 'package:elephant_chat/widgets/chat_list.dart';
import 'package:elephant_chat/widgets/fancy_tab_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final List<TabItem> tabList = [
    TabItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
    TabItem(icon: Icons.person_outline, title: 'Contacts'),
    TabItem(icon: Icons.settings_outlined, title: 'Settings'),
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
