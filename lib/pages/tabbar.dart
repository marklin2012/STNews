import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/home/home.dart';
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
        PersonPage(),
      ],
      items: [
        const BottomNavigationBarItem(
            icon: Icon(
              STIcons.commonly_home,
              size: 28,
            ),
            label: '资讯'),
        const BottomNavigationBarItem(
            icon: Icon(
              STIcons.commonly_user,
              size: 28,
            ),
            label: '我的'),
      ],
    );
  }
}
