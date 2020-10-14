// import 'package:elephant_chat/widgets/animated_tab_bar.dart';
import 'package:elephant_chat/common/consts.dart';
import 'package:flutter/material.dart';
import './routes/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: BottomBarNavigationPatternExample(),
    // );
    return MaterialApp(
      title: 'EleChat',
      theme: ThemeData(primaryColor: primaryColor),
      home: MyHomePage(),
    );
  }
}
