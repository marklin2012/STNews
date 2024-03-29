import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/tabbar.dart';
import 'package:stnews/providers/circle_detail_provider.dart';
import 'package:stnews/providers/circle_provider.dart';
import 'package:stnews/providers/circle_search_provider.dart';
import 'package:stnews/providers/color_theme_provider.dart';
import 'package:stnews/providers/favourited_post_provider.dart';
import 'package:stnews/providers/favourited_user_provider.dart';
import 'package:stnews/providers/home_post_provider.dart';
import 'package:stnews/providers/notice_provider.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/providers/post_search_provider.dart';
import 'package:stnews/providers/user_home_provider.dart';

import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

void main() {
  // init API dio
  Api.initAPI();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});

  /// 服务器token
  /// ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({
  //   'token':
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIxNTg4ODg4ODg4OCIsImlkIjoiNjE1NTFlMTdjNjI4ODMyYjBjMjIyZDlkIiwiaWF0IjoxNjM3NTQ4MjcyfQ.Umh6-tlYXxGoIDa4_2w7sKwFNAqU_n09YM28LWUKaYI',
  //   'user':
  //       '{"_id":"61551e17c628832b0c222d9d","mobile":"15888888888","__v":0,"nickname":"curry","sex":0}'
  // });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ColorThemeProvider.shared),
        ChangeNotifierProvider.value(value: UserProvider.shared),
        ChangeNotifierProvider.value(value: HomePostProvider()),
        ChangeNotifierProvider.value(value: PostSearchProvider()),
        ChangeNotifierProvider.value(value: PostDetailProvider()),
        ChangeNotifierProvider.value(value: UserHomeProvider()),
        ChangeNotifierProvider.value(value: FavouritedPostProvider()),
        ChangeNotifierProvider.value(value: FavouritedUserProvider()),
        ChangeNotifierProvider.value(value: NoticeProvider()),
        ChangeNotifierProvider.value(value: CircleProvider()),
        ChangeNotifierProvider.value(value: CircleDetailProvider()),
        ChangeNotifierProvider.value(value: CircleSearchProvider()),
      ],
      child: MyApp(),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorConfig.primaryColor,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorThemeProvider>(builder: (context, colorTheme, _) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'STNews',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: ColorConfig.primaryColor,
            titleTextStyle: NewsTextStyle.style18BoldBlack,
            iconTheme: IconThemeData(
              color: ColorConfig.textFirColor,
            ),
            elevation: 0.1,
            centerTitle: true,
            toolbarHeight: 44,
          ),
          primaryColor: ColorConfig.primaryColor,
          backgroundColor: ColorConfig.primaryColor,
          scaffoldBackgroundColor: ColorConfig.primaryColor,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ColorConfig.accentColor),
          fontFamily: 'PingFang',
        ),
        routes: STRouters.routes,
        onGenerateRoute: STRouters.onGenerateRoute,
        initialRoute: UserProvider.shared.isLogin
            ? TabbarPage.routeName
            : LoginPage.routeName,
      );
    });
  }
}
