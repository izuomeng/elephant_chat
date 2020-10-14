import 'package:flutter/material.dart';

class AnimateIconColor extends ImplicitlyAnimatedWidget {
  final Color color;
  final IconData icon;

  AnimateIconColor(
      {Key key,
      @required this.color,
      @required this.icon,
      Curve curve = Curves.easeInOut,
      Duration duration = const Duration(milliseconds: 150)})
      : super(key: key, duration: duration, curve: curve);

  @override
  _AnimateIconColorState createState() => _AnimateIconColorState();
}

class _AnimateIconColorState extends AnimatedWidgetBaseState<AnimateIconColor> {
  ColorTween _color;

  @override
  Widget build(BuildContext context) {
    return Icon(widget.icon, color: _color.evaluate(animation));
  }

  @override
  void forEachTween(visitor) {
    _color = visitor(_color, widget.color, (value) => ColorTween(begin: value));
  }
}
