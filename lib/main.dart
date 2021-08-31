import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stnews/common/global.dart';

import 'package:stnews/login/login_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/tabbar/tabbar.dart';

void main() {
  // init API dio
  Api.initAPI();

  /// 处理报错
  /// 不设置的话会出现错误Unhandled Exception: Null Check Operator Used On A Null Value
  SharedPreferences.setMockInitialValues({});

  Global.init().then((_) => runApp(MyApp()));
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
      home: _configPage(),
    );
  }

  Widget _configPage() {
    if (Global.profile.isLogin != null && Global.profile.isLogin!) {
      return TabbarPage();
    }
    return LoginPage();
  }
}
