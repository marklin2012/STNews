import 'package:flutter/material.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/tabbar.dart';

class STRouters {
  static Future push(BuildContext context, Widget widget,
      {String? routeName}) async {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext buildContext) => widget,
        settings: RouteSettings(name: routeName)));
  }

  static Future pop(BuildContext context) async {
    return Navigator.of(context).maybePop();
  }

  static Future pushReplace(BuildContext context, String routeName) async {
    return Navigator.of(context).pushReplacementNamed(routeName);
  }

  static final Map<String, WidgetBuilder> routes = {
    LoginPage.routeName: (context) => LoginPage(),
    TabbarPage.routeName: (context) => TabbarPage(),
  };

  static final RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
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
  };
}

class BlankPutKeyborad extends StatelessWidget {
  const BlankPutKeyborad({Key? key, required this.child, this.onTap})
      : super(key: key);

  final Widget child;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) onTap!();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
