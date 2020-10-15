import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/entities/chat_sessions.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatSessions> _chatList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildAppBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
        leading: Icon(
          Icons.notifications_outlined,
          color: Colors.black87,
        ),
        title: CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
            'https://img.alicdn.com/tfs/TB1S7v7Y4v1gK0jSZFFXXb0sXXa-190-183.jpg',
          ),
        ),
        centerTitle: true,
        backgroundColor: bodyBg,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 24,
              color: Colors.black87,
            ),
            onPressed: null,
          ),
        ],
        elevation: 0);
  }

  Widget _buildAppBody() {
    return ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              child: Text(
                'Chats',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.all(20),
            );
          }
          return Text(index.toString());
        });
  }

  void _fetchChatList() {
    // url: https://mocks.alibaba-inc.com/mock/daxiang-test/chat/sessions
  }
}
