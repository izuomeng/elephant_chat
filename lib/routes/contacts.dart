import 'dart:developer';

import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/request.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:elephant_chat/widgets/light_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  User _loginUser;
  List<User> _contactList = [];

  @override
  void initState() {
    super.initState();
    _fetchContactList();
  }

  Future<void> _fetchContactList() async {
    User loginUser = _loginUser ?? await EleUtils.getLoginUser();
    var res = await request
        .get('/friend/now', queryParameters: {'uid': loginUser.id});

    List<User> contactList = [];

    res.data.forEach((item) {
      contactList.add(User.fromJson(item));
    });

    _buildContactList(contactList);

    setState(() {
      _contactList = contactList;

      if (_loginUser is! User) {
        _loginUser = loginUser;
      }
    });
  }

  Widget _buildContactItem(User contact) {
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
  }

  String _getPinyin(String word) {
    RegExp reg = RegExp(r'[\u4e00-\u9fa5]+');

    if (reg.hasMatch(word)) {
      try {
        return PinyinHelper.getPinyin(word);
      } catch (e) {
        print(e);
        return word;
      }
    }
    return word;
  }

  List<Widget> _buildFloatedNavText(List<User> userList) {
    TextStyle floatNavStyle = TextStyle(color: Colors.black45, fontSize: 12);
    List<String> firstLetterList = userList
        .map((user) {
          String firstLetterUpper = _getPinyin(user.name)[0].toUpperCase();
          return _isAToZ(firstLetterUpper) ? firstLetterUpper : '#';
        })
        .toSet()
        .toList()
          ..sort((x, y) {
            if (!_isAToZ(x)) {
              return 1;
            }
            return x.compareTo(y);
          });
    return firstLetterList
        .map((firstLetter) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                firstLetter,
                style: floatNavStyle,
              ),
            ))
        .toList();
  }

  bool _isAToZ(String letter) {
    RegExp reg = RegExp(r'[A-Z]+');
    return reg.hasMatch(letter);
  }

  List<Widget> _buildContactList(List<User> contactList) {
    List<Widget> result = [BigTitle(title: 'Contacts')];

    List<Map> listWithPinyin = contactList
        .map((item) =>
            {'pinyin': _getPinyin(item.name).toLowerCase(), 'user': item})
        .toList();

    listWithPinyin.sort((x, y) {
      if (!_isAToZ(x['pinyin'][0].toUpperCase())) {
        return 1;
      }
      return x['pinyin'].compareTo(y['pinyin']);
    });

    String prevLetter = '';

    for (var item in listWithPinyin) {
      String pinyin = item['pinyin'];
      User contact = item['user'];
      String firstLetter = pinyin[0].toUpperCase();

      if (!_isAToZ(firstLetter)) {
        firstLetter = '#';
      }

      if (firstLetter == prevLetter) {
        result.add(_buildContactItem(contact));
      } else {
        result.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Text(
            firstLetter,
            style:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.black45),
          ),
        ));
        result.add(_buildContactItem(contact));
        prevLetter = firstLetter;
      }
    }

    return result;
  }

  Widget _buildAppBody() {
    List<Widget> widgetList = _buildContactList(_contactList);

    return Stack(
      fit: StackFit.expand,
      children: [
        ListView.builder(
            itemCount: widgetList.length,
            itemBuilder: (context, index) => widgetList[index]),
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildFloatedNavText(_contactList),
          ),
        )
      ],
    );
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
