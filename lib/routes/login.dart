import 'dart:async';

import 'package:elephant_chat/common/chat_client.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/widgets/count_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isValidNumber = false;
  String _phoneNumber = '';

  void _handleNext() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ConfirmationCodePage(
                  phoneNumber: '+86 $_phoneNumber',
                )));
  }

  void _handleChange(String text) {
    _phoneNumber = text;
    if (text.length == 11) {
      setState(() {
        _isValidNumber = true;
      });
    } else {
      setState(() {
        _isValidNumber = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    double sreenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () => EleUtils.hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Enter your\nmobile number',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'We will send you a confirmation code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Text(
                        '+86',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 28),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            hintText: "123-4567-8910",
                            hintStyle: TextStyle(color: Colors.black38),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                        onChanged: _handleChange,
                      )),
                    ],
                  )
                ],
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: TextButton(
            onPressed: _isValidNumber ? _handleNext : null,
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.disabled)
                        ? Color(0xffF4F5F7)
                        : primaryColor),
                foregroundColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.disabled)
                        ? Colors.black26
                        : Colors.white),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16)),
                minimumSize:
                    MaterialStateProperty.all(Size(sreenWidth - 64, 0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))),
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}

class ConfirmationCodePage extends StatefulWidget {
  final String phoneNumber;

  ConfirmationCodePage({@required this.phoneNumber});

  @override
  _ConfirmationCodePageState createState() => _ConfirmationCodePageState();
}

class _ConfirmationCodePageState extends State<ConfirmationCodePage> {
  bool _isCountDownDone = false;
  bool _isLoading = false;
  String _cuurentCode = '';

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      SmsAutoFill().listenForCode;
    });
  }

  void _handleCodeChange(String code) {
    setState(() {
      _cuurentCode = code;
    });
    if (code == '1234') {
      setState(() {
        _isLoading = true;
      });
      Timer(Duration(seconds: 2), () async {
        User user =
            await chatClient.getUserByPhone(widget.phoneNumber.substring(4));
        // User user = User(
        //     id: 'klmklm2',
        //     avatar:
        //         'https://img.alicdn.com/tfs/TB1S7v7Y4v1gK0jSZFFXXb0sXXa-190-183.jpg',
        //     name: '克拉默',
        //     phone: '11122233344');

        if (user is User) {
          await EleUtils.setLoginUser(user);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          // TODO: 注册用户
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    double sreenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => EleUtils.hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter code sent\nto your number',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'We sent it to number ${widget.phoneNumber}',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
              ),
              SizedBox(
                height: 24,
              ),
              PinFieldAutoFill(
                codeLength: 4,
                currentCode: _cuurentCode,
                decoration: const UnderlineDecoration(
                    colorBuilder: FixedColorBuilder(Colors.black),
                    textStyle: TextStyle(color: Colors.black, fontSize: 24)),
                onCodeChanged: _handleCodeChange,
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isLoading
            ? CupertinoActivityIndicator(
                radius: 15,
              )
            : _isCountDownDone
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        _isCountDownDone = false;
                      });
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(sreenWidth - 64, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                    child: Text('Send code'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Resend code in '),
                      SizedBox(
                        width: 24,
                        child: Align(
                          heightFactor: 1,
                          alignment: Alignment.center,
                          child: CountDown(
                            start: 59,
                            autoStart: true,
                            onFinish: () {
                              setState(() {
                                _isCountDownDone = true;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(' seconds')
                    ],
                  ),
      ),
    );
  }
}
