import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:elephant_chat/common/chat_client.dart';
import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/chat_session.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/routes/chat.dart';
import 'package:elephant_chat/widgets/light_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatSession> _chatList = [];
  User _loginUser;

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
            _loginUser?.avatar ?? DEFAULT_AVATAR_URL,
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
            return BigTitle(
              title: 'Chats',
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
                        DateFormat.jm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                chatSession.lastMessageTime)),
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
    User loginUser = _loginUser ?? await EleUtils.getLoginUser();

    List<ChatSession> chatList =
        await chatClient.getConversationList(loginUser.id);

    // 新消息排在最前面
    chatList
        .sort((left, right) => right.lastMessageTime - left.lastMessageTime);
    // 加一个占位符，渲染标题
    setState(() {
      _chatList = [null, ...chatList];
      if (_loginUser is! User) {
        _loginUser = loginUser;
      }
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
