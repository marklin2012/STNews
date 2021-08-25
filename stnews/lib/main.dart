import 'package:flutter/material.dart';

import 'package:stnews/login/login_page.dart';
import 'package:stnews/tabbar/tabbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STNews',
      theme: ThemeData(
        // 配置主色
        primaryColor: Colors.white,
        // 配置背景色
        backgroundColor: Color(0xFFFAFCFF),
        // 配置前景色
        accentColor: Color(0xFF4585FF),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.1,
        ),
      ),
      home: _configPage(false),
    );
  }

  Widget _configPage(bool isLogin) {
    // 未登录
    if (!isLogin) {
      return LoginPage();
    }
    return TabbarPage();
  }
}
