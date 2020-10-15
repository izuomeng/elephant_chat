import 'dart:ffi';

import 'package:flutter/material.dart';

class AnimatedColorIcon extends ImplicitlyAnimatedWidget {
  final Color color;
  final IconData icon;
  final double size;

  AnimatedColorIcon(
      {Key key,
      @required this.color,
      @required this.icon,
      this.size,
      Duration duration = const Duration(milliseconds: 150)})
      : super(key: key, duration: duration, curve: Curves.easeInOut);

  @override
  _AnimateIconColorState createState() => _AnimateIconColorState();
}

class _AnimateIconColorState
    extends AnimatedWidgetBaseState<AnimatedColorIcon> {
  ColorTween _color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      color: _color.evaluate(animation),
      size: widget.size,
    );
  }

  @override
  void forEachTween(visitor) {
    _color = visitor(_color, widget.color, (value) => ColorTween(begin: value));
  }
}
