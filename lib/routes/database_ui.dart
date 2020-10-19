import 'package:elephant_chat/common/chat_client.dart';
import 'package:flutter/material.dart';

class DataBaseUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: chatClient.buildDatabaseUI(),
        builder: (context, snapshot) {
          // 请求已结束
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        });
  }
}
