import 'package:elephant_chat/common/utils.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  _handleLogout() async {
    final isConfirm = await _showConfirmDialog();
    if (isConfirm) {
      EleUtils.clearLoginUser();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<bool> _showConfirmDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm logout ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Settings'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: ElevatedButton(
            onPressed: _handleLogout,
            child: Text('Logout'),
            style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 36)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          )),
    );
  }
}
