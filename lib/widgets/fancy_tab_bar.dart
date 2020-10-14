import 'package:elephant_chat/common/consts.dart';
import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/widgets/animate_icon_color.dart';
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
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 20)
          ]),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 32.0,
          top: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _renderTabItems(),
        ),
      ),
    );
  }

  List<Widget> _renderTabItems() {
    return EleUtils.jsMap<TabItem, Widget>(widget.tablist)
        .map((item, index) => Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentTab = index;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimateIconColor(
                    icon: item.icon,
                    color:
                        currentTab == index ? primaryColor : Color(0xffC4C7CD),
                  ),
                  SizedBox(height: 8),
                  AnimatedDefaultTextStyle(
                      child: Text(item.title),
                      style: TextStyle(
                          color: currentTab == index
                              ? primaryColor
                              : Color(0xffCED0D4)),
                      duration: Duration(milliseconds: 150))
                ],
              ),
            )));
  }
}

class TabItem {
  String title;
  IconData icon;

  TabItem({@required this.icon, @required this.title});
}
