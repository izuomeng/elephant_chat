import 'dart:async';

import 'package:flutter/material.dart';

class TestFlutter extends StatefulWidget {
  @override
  _TestFlutterState createState() => _TestFlutterState();
}

class _TestFlutterState extends State<TestFlutter> {
  int n = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(n.toString()),
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  n++;
                });
                Timer(Duration(milliseconds: 1), () {
                  setState(() {
                    n++;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
