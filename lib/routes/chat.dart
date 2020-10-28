import 'dart:async';
import 'dart:developer';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/socket_message.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:elephant_chat/common/chat_client.dart';
import 'package:elephant_chat/entities/chat_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatTitle;
  final String chatSubTitle;
  final String chatAvatar;
  final String chatId;

  ChatPage(
      {@required this.chatTitle,
      @required this.chatAvatar,
      @required this.chatId,
      this.chatSubTitle});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> _chatList = [];
  LoginUserNotifier _loginUser;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    chatClient.registerMessageHook(handleReceiveMessage);
    await _fetchChatList();
    _scrollController.jumpTo(10000000);
  }

  @override
  void dispose() {
    super.dispose();
    chatClient.unregisterMessageHook(handleReceiveMessage);
  }

  void handleReceiveMessage(ChatMessage message) {
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    List<ChatMessage> chatList =
        await chatClient.getRelatedMessages(widget.chatId);
    setState(() {
      _chatList = chatList;

      if (_loginUser is LoginUserNotifier) {
        return;
      }
      LoginUserNotifier loginUser =
          Provider.of<LoginUserNotifier>(context, listen: false);
      _loginUser = loginUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildChatList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ChatMessage chatMessage = ChatMessage(
              id: EleUtils.generateId(),
              type: 1,
              sender: User(
                  id: _loginUser.id,
                  avatar: _loginUser.avatar,
                  name: _loginUser.name),
              text: 'xxxxx',
              time: DateTime.now().millisecondsSinceEpoch,
              haveRead: 'n',
              receiverId: widget.chatId);
          chatClient.sendMessage(SocketMessage(100, chatMessage));
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.chatAvatar),
            radius: 24,
          ),
          SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 4,
              ),
              Text(widget.chatSubTitle,
                  style: TextStyle(fontSize: 14, color: Colors.black45))
            ],
          )
        ],
      ),
      bottom: PreferredSize(
        child: Divider(
          color: Colors.black26,
          height: 1,
          thickness: 0,
        ),
        preferredSize: Size.fromHeight(12),
      ),
    );
  }

  Widget _buildChatList() {
    double bubbleWidth = MediaQuery.of(context).size.width * 0.8;

    return ListView.builder(
        controller: _scrollController,
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          ChatMessage chatMessage = _chatList[index];
          bool isFromFriend = chatMessage.receiverId == _loginUser?.id;

          return Row(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: bubbleWidth),
                margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                // child: Text(chatMessage.text),
                child: isFromFriend
                    ? ChatBubble.friend(chatMessage.text)
                    : ChatBubble.self(chatMessage.text, context),
              )
            ],
            mainAxisAlignment:
                isFromFriend ? MainAxisAlignment.start : MainAxisAlignment.end,
          );
        });
  }
}
