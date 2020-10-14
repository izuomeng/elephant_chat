import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:flutter/material.dart';

class FancyTabBar extends StatefulWidget {
  final List<TabItem> tablist;

  FancyTabBar({@required this.tablist});

  @override
  _FancyTabBarState createState() => _FancyTabBarState();
}

class _FancyTabBarState extends State<FancyTabBar> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.2), blurRadius: 10)
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _renderTabItems(),
        ),
      ),
    );
  }

  List<Widget> _renderTabItems() {
    return EleUtils.jsMap<TabItem, Widget>(widget.tablist)
        .map((item, index) => InkWell(
              splashColor: Color.fromRGBO(0, 0, 0, 0.1),
              onTap: () {
                setState(() {
                  currentTab = index;
                });
              },
              child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      item.icon,
                      color: currentTab == index
                          ? primaryColor
                          : Color(0xffC4C7CD),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.title,
                      style: TextStyle(
                          color: currentTab == index
                              ? primaryColor
                              : Color(0xffCED0D4)),
                    )
                  ],
                ),
              ),
            ));
  }
}

class TabItem {
  String title;
  IconData icon;
  Color color;

  TabItem({@required this.icon, @required this.title, @required this.color});
}
