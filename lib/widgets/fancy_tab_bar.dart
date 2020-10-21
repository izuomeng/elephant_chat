import 'package:elephant_chat/common/utils.dart';
import 'package:elephant_chat/entities/tab_item.dart';
import 'package:elephant_chat/widgets/animated_color_icon.dart';
import 'package:flutter/material.dart';

class FancyTabBar extends StatefulWidget {
  final List<TabItem> tablist;
  final void Function(int) onTap;
  final int defaultActiveTab;

  FancyTabBar({@required this.tablist, this.onTap, this.defaultActiveTab = 0});

  @override
  _FancyTabBarState createState() => _FancyTabBarState();
}

class _FancyTabBarState extends State<FancyTabBar> {
  int currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = widget.defaultActiveTab;
  }

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
          children: _renderTabItems(context),
        ),
      ),
    );
  }

  List<Widget> _renderTabItems(BuildContext context) {
    const duration = Duration(milliseconds: 150);
    Color primaryColor = Theme.of(context).primaryColor;

    return EleUtils.jsMap<TabItem, Widget>(widget.tablist)
        .map((item, index) => Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentTab = index;
                  if (widget.onTap is Function) {
                    widget.onTap(index);
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedColorIcon(
                    icon: item.icon,
                    color:
                        currentTab == index ? primaryColor : Color(0xffC4C7CD),
                    duration: duration,
                    size: 20,
                  ),
                  SizedBox(height: 8),
                  AnimatedDefaultTextStyle(
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(
                          color: currentTab == index
                              ? primaryColor
                              : Color(0xffCED0D4)),
                      duration: duration)
                ],
              ),
            )));
  }
}
