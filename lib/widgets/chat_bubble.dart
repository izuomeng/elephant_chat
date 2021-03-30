import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  static const _defaultBubbleColor = const Color(0xffEBECF2);
  static const _radius = const Radius.circular(8);

  final String text;
  final Color _bubbleColor;
  final Color _textColor;
  final BorderRadius _borderRadius;
  final VertexPoint _bubbleDerection;

  ChatBubble.friend(this.text)
      : _borderRadius = BorderRadius.only(
            topLeft: _radius, topRight: _radius, bottomRight: _radius),
        _bubbleColor = _defaultBubbleColor,
        _textColor = Color(0xff767C8B),
        _bubbleDerection = VertexPoint.bottomRight;

  ChatBubble.self(this.text, BuildContext context)
      : _borderRadius = BorderRadius.only(
            topLeft: _radius, topRight: _radius, bottomLeft: _radius),
        _bubbleColor = Theme.of(context).primaryColor,
        _textColor = Colors.white,
        _bubbleDerection = VertexPoint.bottomLeft;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(height: 1.5, fontSize: 14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _bubbleColor,
                borderRadius: _borderRadius,
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                text,
                style: TextStyle(color: _textColor),
              ),
            ),
            Positioned(
                left: _bubbleDerection == VertexPoint.bottomLeft ? null : -10,
                right: _bubbleDerection == VertexPoint.bottomRight ? null : -10,
                bottom: 0,
                child: CustomPaint(
                  painter: TrianglePainter(
                      fillColor: _bubbleColor, vertexPoint: _bubbleDerection),
                  size: Size(10, 10),
                ))
          ],
        ));
  }
}

enum VertexPoint { topLeft, topRight, bottomLeft, bottomRight }

class TrianglePainter extends CustomPainter {
  final Color fillColor;
  final VertexPoint vertexPoint;

  TrianglePainter(
      {this.fillColor = Colors.black,
      this.vertexPoint = VertexPoint.bottomLeft});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    Paint fill = Paint()
      ..isAntiAlias = true
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round;

    Path path = Path();

    // TODO: 实现剩余两个顶点的三角形绘制
    switch (vertexPoint) {
      case VertexPoint.bottomLeft:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..lineTo(0, 0);
        break;
      case VertexPoint.bottomRight:
        path
          ..moveTo(size.width, size.height)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height);
        break;
      default:
        break;
    }

    canvas.drawPath(path, fill);
  }
}
