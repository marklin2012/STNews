import 'package:flutter/material.dart';
import 'package:stnews/main.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/utils/st_routers.dart';

class TokenInvalid {
  static bool invalidTokenToLogin = false;

  /// token失效统一处理
  static isTokenInvalid(int? code) {
    if (code != null && code == 500) {
      if (!invalidTokenToLogin) {
        invalidTokenToLogin = true;

        /// token失效
        BuildContext? context = navigatorKey.currentState?.overlay?.context;
        if (context != null) {
          STRouters.push(context, LoginPage(), routeName: LoginPage.routeName);
        }
      }
    }
  }

  static resetInvalidCount() {
    invalidTokenToLogin = false;
  }
}
