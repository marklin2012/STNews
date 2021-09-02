import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stnews/login/login_page.dart';
import 'package:stnews/login/model/user_manager.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/sharedpreferences/shared_pref.dart';
import 'package:stnews/tabbar/tabbar.dart';

void main() {
  // init API dio
  Api.initAPI();

  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  SharedPreferences.setMockInitialValues({
    'token':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIxMjMgNDU2NyIsImlhdCI6MTYzMDUwNTEzN30.SCtRhjDnjzKS9W_fUf7oFvMAWq8LFtgv-kizP9iBovw',
    'user':
        '{"_id":"612e2506573ba7d30affe47c","mobile":"123 4567","__v":0,"nickname":"用户567 506","sex":0}'
  });

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => UserManager.shared),
        ChangeNotifierProvider.value(value: UserManager.shared),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _futrueIsLogin() async {
    String? token = await SharedPref.getToken();
    if (token != null) {
      return true;
    }
    return false;
  }

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
      home: FutureBuilder(
          future: _futrueIsLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final _isLogin = snapshot.data as bool;
              if (_isLogin) return TabbarPage();
            }
            return LoginPage();
          }),
    );
  }
}
