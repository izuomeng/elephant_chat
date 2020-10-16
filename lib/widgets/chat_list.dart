import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/request.dart';
import 'package:elephant_chat/entities/chat_session.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatSession> _chatList = [];

  @override
  void initState() {
    super.initState();
    _fetchChatList();
  }

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

          ChatSession chatSession = _chatList[index];
          int unreadMessageCnt = chatSession.messages
              .where((element) => element.haveRead == 'n')
              .length;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  chatSession.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  chatSession.messages?.last?.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              leading: CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(chatSession.userAvatar),
              ),
              trailing: unreadMessageCnt > 0
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFF6766),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: Text(
                        unreadMessageCnt.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : null,
            ),
          );
        });
  }

  void _fetchChatList() async {
    // url: https://mocks.alibaba-inc.com/mock/daxiang-test/chat/sessions
    Response response = await request.get('/chat/sessions');
    List chatSessionMaps = response.data ?? [];
    List<ChatSession> chatList = [null]; // 加一个占位符，渲染标题

    for (var chatSessionMap in chatSessionMaps) {
      chatList.add(ChatSession.fromJson(chatSessionMap));
    }

    setState(() {
      _chatList = chatList;
    });
  }
}
