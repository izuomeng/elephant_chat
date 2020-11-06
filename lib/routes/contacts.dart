import 'dart:developer';

import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/request.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/widgets/light_widgets.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  User _loginUser;
  List<User> _contactList;

  @override
  void initState() {
    super.initState();
    _fetchContactList();
  }

  Future<void> _fetchContactList() async {
    User loginUser = _loginUser ?? await EleUtils.getLoginUser();
    var res = await request
        .get('/friend/now', queryParameters: {'uid': loginUser.id});

    List<User> contactList = [null];

    res.data.forEach((item) {
      contactList.add(User.fromJson(item));
    });

    setState(() {
      _contactList = contactList;

      if (_loginUser is! User) {
        _loginUser = loginUser;
      }
    });
  }

  Widget _buildAppBody() {
    return ListView.builder(
        itemCount: _contactList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return BigTitle(title: 'Contacts');
          }

          User contact = _contactList[index];
          return ListTile(
            dense: true,
            key: Key(contact.id),
            contentPadding: EdgeInsets.symmetric(horizontal: 18),
            leading: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(contact.avatar),
            ),
            title: Text(
              contact.name,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              _loginUser?.avatar ?? DEFAULT_AVATAR_URL,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person_add_alt,
                size: 24,
                color: Colors.black87,
              ),
              onPressed: null,
            ),
          ],
          elevation: 0),
      body: _buildAppBody(),
    );
  }
}
