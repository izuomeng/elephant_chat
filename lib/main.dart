// import 'package:elephant_chat/widgets/animated_tab_bar.dart';
import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        lazy: false,
        create: (context) async {
          return LoginUserNotifier(
              id: 'klmklm',
              avatar:
                  'https://img.alicdn.com/tfs/TB1S7v7Y4v1gK0jSZFFXXb0sXXa-190-183.jpg',
              name: '克拉默');
        },
        child: MaterialApp(
          title: 'ElephantChat',
          theme: ThemeData(primaryColor: primaryColor),
          home: Home(),
        ));
  }
}
