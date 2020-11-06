import 'package:flutter/material.dart';

class BigTitle extends StatelessWidget {
  final String title;

  BigTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text(
        title,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.all(20),
    );
  }
}
