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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  height: 8,
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
      ),
    );
  }
}
