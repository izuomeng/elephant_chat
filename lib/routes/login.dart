import 'dart:async';

import 'package:elephant_chat/common/utils.dart';
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
          floatingActionButton: FlatButton(
            onPressed: _isValidNumber ? _handleNext : null,
            color: primaryColor,
            disabledTextColor: Colors.black26,
            disabledColor: Color(0xffF4F5F7),
            minWidth: sreenWidth - 64,
            colorBrightness: Brightness.dark,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
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
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      SmsAutoFill().listenForCode;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: const UnderlineDecoration(
                    colorBuilder: FixedColorBuilder(Colors.black),
                    textStyle: TextStyle(color: Colors.black, fontSize: 24)),
              )
            ],
          ),
        ),
      ),
    );
  }
}