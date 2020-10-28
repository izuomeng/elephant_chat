import 'package:flutter/material.dart';

const _defaultBubbleColor = const Color(0xffEBECF2);
const _radius = Radius.circular(12);
BoxDecoration _friendBubbleBox = BoxDecoration(
    color: _defaultBubbleColor,
    borderRadius: BorderRadius.only(
        topLeft: _radius, topRight: _radius, bottomRight: _radius));
TextStyle _friendBubbleTextStyle = TextStyle(color: Color(0xff838797));

class ChatBubble extends StatelessWidget {
  final String text;
  final BoxDecoration _bubbleBoxDecoration;
  final TextStyle _bubbleTextStyle;

  ChatBubble.friend(this.text)
      : _bubbleBoxDecoration = _friendBubbleBox,
        _bubbleTextStyle = _friendBubbleTextStyle;

  ChatBubble.self(this.text, BuildContext context)
      : _bubbleBoxDecoration = BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: _radius, topRight: _radius, bottomLeft: _radius)),
        _bubbleTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(height: 1.5, fontSize: 14),
        child: Container(
          decoration: _bubbleBoxDecoration,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            text,
            style: _bubbleTextStyle,
          ),
        ));
  }
}
