// import 'package:elephant_chat/widgets/animated_tab_bar.dart';

import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/routes/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routes/home.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElephantChat',
      theme: ThemeData(
          primaryColor: PRIMARY_COLOR,
          backgroundColor: BODY_BG,
          scaffoldBackgroundColor: BODY_BG),
      // home: Home(),
      home: UserCheck(),
      routes: {'/login': (context) => Login(), '/home': (context) => Home()},
    );
  }
}

class UserCheck extends StatefulWidget {
  @override
  _UserCheckState createState() => _UserCheckState();
}

class _UserCheckState extends State<UserCheck> {
  bool _hasUser = false;

  @override
  void initState() {
    super.initState();

    EleUtils.getLoginUser().then((user) {
      if (user is User) {
        setState(() {
          _hasUser = true;
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _hasUser
        ? Home()
        : Center(
            child: CupertinoActivityIndicator(
              radius: 15,
            ),
          );
  }
}
