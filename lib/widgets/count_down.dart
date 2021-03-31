import 'dart:async';
import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  final int start;
  final int end;
  final Duration duration;
  final bool autoStart;
  final CountDownController controller;
  final TextStyle textStyle;
  final void Function() onFinish;

  CountDown(
      {@required this.start,
      this.end = 0,
      this.duration = const Duration(seconds: 1),
      this.autoStart = true,
      this.controller,
      this.textStyle = const TextStyle(color: Colors.black),
      this.onFinish});

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  int _currentValue;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.start;

    if (widget.autoStart) {
      start();
    }

    if (widget.controller is CountDownController) {
      widget.controller.init(
          start: start,
          stop: () {
            _timer?.cancel();
          },
          reset: () {
            setState(() {
              _timer?.cancel();
              _currentValue = widget.start;
              start();
            });
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void start() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_currentValue <= widget.end) {
        timer.cancel();

        if (widget.onFinish is Function) {
          widget.onFinish();
        }
      } else {
        setState(() {
          _currentValue = _currentValue - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentValue.toString(),
      style: widget.textStyle,
    );
  }
}

class CountDownController {
  void Function() startCount;
  void Function() stopCount;
  void Function() restartCount;

  void init(
      {void Function() start, void Function() stop, void Function() reset}) {
    startCount = start;
    stopCount = stop;
    restartCount = reset;
  }
}
