import 'dart:async';
import 'dart:ui';
import 'package:elephant_chat/common/chat_client.dart';
import 'package:elephant_chat/entities/chat_session.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/routes/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatSession> _chatList = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _fetchChatList(context);
      chatClient.registerMessageHook((message) {
        _fetchChatList(context);
      });
    });
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
        backgroundColor: Theme.of(context).backgroundColor,
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
          int unreadMessageCnt = chatSession.unreadCnt;
          double sreenWidth = MediaQuery.of(context).size.width;
          double maxSubtitleWidth =
              unreadMessageCnt > 0 ? sreenWidth - 216 : sreenWidth - 180;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              key: Key(chatSession.id),
              onTap: () => _handleClickListItem(chatSession),
              title: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  chatSession.userName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 4),
                child: DefaultTextStyle(
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: maxSubtitleWidth),
                        child: Text(chatSession.lastMessageContent,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(fontSize: 20, color: Colors.black45),
                      ),
                      Text(
                        '5:46 PM',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      )
                    ])),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
            ),
          );
        });
  }

  void _fetchChatList(BuildContext context) async {
    // chatClient.insertMockData();
    LoginUserNotifier loginUser = context.read<LoginUserNotifier>();

    List<ChatSession> chatList =
        await chatClient.getConversationList(loginUser.id); // 加一个占位符，渲染标题
    setState(() {
      _chatList = [null, ...chatList];
    });
  }

  void _handleClickListItem(ChatSession chatSession) {
    String lastMessageTime = DateFormat('HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(chatSession.lastMessageTime));
    ChatPage chatPage = ChatPage(
      chatTitle: chatSession.userName,
      chatAvatar: chatSession.userAvatar,
      chatId: chatSession.id,
      chatSubTitle: 'Last Seen $lastMessageTime',
    );

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => chatPage));
  }
}
