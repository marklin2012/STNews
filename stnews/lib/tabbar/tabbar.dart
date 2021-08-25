import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/circle/circle.dart';
import 'package:stnews/home/home.dart';
import 'package:stnews/mall/mall.dart';
import 'package:stnews/person/person.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({Key? key}) : super(key: key);

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  @override
  Widget build(BuildContext context) {
    return STTabbar(
      pages: [
        HomePage(),
        MallPage(),
        CirclePage(),
        PersonPage(),
      ],
      items: [
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_ashcan), label: '资讯'),
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_share), label: '商城'),
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_calendar), label: '圈圈'),
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_score), label: '我的'),
      ],
    );
  }
}
