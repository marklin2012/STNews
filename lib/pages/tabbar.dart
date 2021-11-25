import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_page.dart';

import 'package:stnews/pages/home/home_page.dart';
import 'package:stnews/pages/person/person.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({Key? key}) : super(key: key);

  static const routeName = '/tabbar';

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  @override
  Widget build(BuildContext context) {
    return STTabbar(
      pages: [
        HomePage(),
        CirclePage(),
        PersonPage(),
      ],
      items: [
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_home), label: '资讯'),
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_fire), label: '圈圈'),
        const BottomNavigationBarItem(
            icon: Icon(STIcons.commonly_user), label: '我的'),
      ],
    );
  }
}
