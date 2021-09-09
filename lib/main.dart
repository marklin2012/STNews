import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/tabbar.dart';

import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';

void main() {
  // init API dio
  Api.initAPI();

  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({
    'token':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIxMjM0NTY3IiwiaWQiOiI2MTM0YzJiZDU2MmIyYTAzODM5ZDk2NDQiLCJpYXQiOjE2MzA4NDc3ODB9.4tU4ApD4Bz3fEvc8rUZbhi4-Xa8ChNrxrSZ4qmjeHGM',
    'user':
        '{"_id":"6134c2bd562b2a03839d9644","mobile":"1234567","__v":0,"nickname":"用户4567882","sex":0}'
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.shared),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: UserProvider.shared.isLogin ? TabbarPage() : LoginPage(),
    );
  }
}
