import 'dart:async';
import 'dart:developer';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/socket_message.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/widgets/chat_bubble.dart';
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
  User _loginUser;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    (() async {
      chatClient.registerMessageHook(handleReceiveMessage);
      await _fetchChatList();
      _scrollToBottom();
    })();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToBottom();
  }

  @override
  void dispose() {
    super.dispose();
    chatClient.unregisterMessageHook(handleReceiveMessage);
    // EleUtils.hideKeyboard(context);
    _scrollController.dispose();
  }

  void _scrollToBottom({bool hasAnimation = false}) {
    Timer(Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) {
        return;
      }
      double y = _scrollController.position.maxScrollExtent;
      if (hasAnimation) {
        _scrollController.animateTo(y,
            curve: Curves.easeInOut, duration: Duration(milliseconds: 300));
      } else {
        _scrollController.jumpTo(y);
      }
    });
  }

  Future<void> handleReceiveMessage(ChatMessage message) async {
    await _fetchChatList();
    _scrollToBottom(hasAnimation: true);
  }

  Future<void> _fetchChatList() async {
    List<ChatMessage> chatList =
        await chatClient.getRelatedMessages(widget.chatId);

    if (_loginUser is! User) {
      User loginUser = await EleUtils.getLoginUser();

      setState(() {
        _loginUser = loginUser;
      });
    }

    setState(() {
      _chatList = chatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: GestureDetector(
          onTap: () => EleUtils.hideKeyboard(context),
          child: Column(
            children: [Expanded(child: _buildChatList()), _buildInputArea()],
          ),
        ));
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
                margin: EdgeInsets.only(left: 26, right: 26, top: 16),
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

  Widget _buildInputArea() {
    return SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 30,
                    offset: Offset(0, 10))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 12,
              ),
              Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                        hintText: "Type something",
                        hintStyle: TextStyle(color: Color(0xffC6CCD8)),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.send,
                    onEditingComplete: _sendMessage,
                  )),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
                color: Color(0xffA9B2C7),
              )
            ],
          ),
        ));
  }

  _sendMessage() {
    String text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    ChatMessage chatMessage = ChatMessage(
        id: EleUtils.generateId(),
        type: 1,
        sender: User(
            id: _loginUser.id,
            avatar: _loginUser.avatar,
            name: _loginUser.name,
            phone: _loginUser.phone),
        text: text,
        time: DateTime.now().millisecondsSinceEpoch,
        haveRead: 'n',
        receiverId: widget.chatId);
    chatClient.sendMessage(SocketMessage(100, chatMessage));
    _textController.clear();
  }
}
