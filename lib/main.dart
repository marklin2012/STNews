import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/tabbar.dart';
import 'package:stnews/providers/color_theme_provider.dart';
import 'package:stnews/providers/favourited_post_provider.dart';
import 'package:stnews/providers/favourited_user_provider.dart';
import 'package:stnews/providers/home_post_provider.dart';
import 'package:stnews/providers/notice_provider.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/providers/user_home_provider.dart';

import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';

void main() {
  // init API dio
  Api.initAPI();

  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({
    'token':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIxNTg4ODg4ODg4OCIsImlkIjoiNjE0NmYwNWFjNjcxOWY4NTc1NjgzMDUwIiwiaWF0IjoxNjMyMDM5MDg5fQ.7Q-_n0rgQAuTYHPKJ0f1aPhwkHIky-27MxQZ3trYEG0',
    'user':
        '{"_id":"6146f05ac6719f8575683050","mobile":"15888888888","__v":0,"nickname":"用户8888990","sex":0}'
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ColorThemeProvider.shared),
        ChangeNotifierProvider.value(value: UserProvider.shared),
        ChangeNotifierProvider.value(value: HomePostProvider()),
        ChangeNotifierProvider.value(value: PostDetailProvider()),
        ChangeNotifierProvider.value(value: UserHomeProvider()),
        ChangeNotifierProvider.value(value: FavouritedPostProvider()),
        ChangeNotifierProvider.value(value: FavouritedUserProvider()),
        ChangeNotifierProvider.value(value: NoticeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorThemeProvider>(builder: (context, colorTheme, _) {
      return MaterialApp(
        title: 'STNews',
        theme: ThemeData(
          primaryColor: ColorConfig.primaryColor,
          backgroundColor: ColorConfig.backgroundColor,
          appBarTheme: AppBarTheme(
            color: ColorConfig.primaryColor,
            titleTextStyle: NewsTextStyle.style18BoldBlack,
            iconTheme: IconThemeData(
              color: ColorConfig.textFirColor,
            ),
            elevation: 0.1,
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ColorConfig.accentColor),
        ),
        onGenerateRoute: (setting) {
          switch (setting.name) {
            case LoginPage.routeName:
              return PageRouteBuilder(
                settings: RouteSettings(name: LoginPage.routeName),
                transitionDuration: Duration(milliseconds: 100),
                pageBuilder: (context, animation, secAnimation) => LoginPage(),
              );
            case TabbarPage.routeName:
              return PageRouteBuilder(
                settings: RouteSettings(name: TabbarPage.routeName),
                transitionDuration: Duration(milliseconds: 100),
                pageBuilder: (context, animation, secAnimation) => TabbarPage(),
              );
          }
        },
        initialRoute: UserProvider.shared.isLogin
            ? TabbarPage.routeName
            : LoginPage.routeName,
      );
    });
  }
}
