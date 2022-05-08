import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_page.dart';

import 'package:stnews/pages/home/home_page.dart';
import 'package:stnews/pages/mall/goods/mall_home_page.dart';
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
        MallHomePage(),
        CirclePage(),
        PersonPage(),
      ],
      items: [
        const STBottomNavigationBarItem(
            icon: Icon(STIcons.commonly_home_outline), label: '资讯'),
        const STBottomNavigationBarItem(
            icon: Icon(STIcons.label_gift_outline), label: '商城'),
        const STBottomNavigationBarItem(
            icon: Icon(STIcons.label_fire_outline), label: '圈圈'),
        const STBottomNavigationBarItem(
            icon: Icon(STIcons.commonly_user_outline), label: '我的'),
      ],
    );
  }
}
