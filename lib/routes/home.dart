import 'package:elephant_chat/entities/tab_item.dart';
import 'package:elephant_chat/routes/database_ui.dart';
import 'package:elephant_chat/routes/login.dart';
import 'package:elephant_chat/widgets/chat_list.dart';
import 'package:elephant_chat/widgets/fancy_tab_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final List<TabItem> tabList = [
    TabItem(icon: Icons.person_outline, title: 'Contacts'),
    TabItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
    TabItem(icon: Icons.settings_outlined, title: 'Settings'),
    TabItem(icon: Icons.data_usage_outlined, title: 'DB'),
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 1;

  @override
  Widget build(BuildContext context) {
    Widget placeHolder = Center(
      child: Text('Placeholder'),
    );

    return Scaffold(
      bottomNavigationBar: FancyTabBar(
          tablist: widget.tabList,
          defaultActiveTab: _currentTab,
          onTap: (tab) {
            setState(() {
              _currentTab = tab;
            });
          }),
      body: IndexedStack(
        children: [placeHolder, ChatList(), placeHolder, DataBaseUI()],
        index: _currentTab,
      ),
    );
  }
}
