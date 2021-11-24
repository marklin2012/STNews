import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/tabbar.dart';

enum STRoutersDirection { rightToLeft, bottomToTop, material }

class STRouters {
  static Future push(BuildContext context, Widget widget,
      {String? routeName,
      STRoutersDirection direction = STRoutersDirection.material}) async {
    // return Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext buildContext) => widget,
    //     settings: RouteSettings(name: routeName)));
    switch (direction) {
      case STRoutersDirection.rightToLeft:
        return Navigator.push(
            context, RightToLeftRouter(child: widget, routeName: routeName));
      case STRoutersDirection.bottomToTop:
        return Navigator.push(
            context, BottomToTopRouter(child: widget, routeName: routeName));
      default:
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => widget,
              settings: RouteSettings(name: routeName),
            ));
    }
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

class RightToLeftRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration;
  final Curve curve;
  final String? routeName;

  RightToLeftRouter({
    required this.child,
    this.duration = 500,
    this.curve = Curves.fastOutSlowIn,
    this.routeName,
  }) : super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return child;
          },
          settings: RouteSettings(name: routeName),
          transitionsBuilder: (ctx, a1, a2, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(parent: a1, curve: curve),
              ),
              child: child,
            );
          },
        );
}

class BottomToTopRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration;
  final Curve curve;
  final String? routeName;

  BottomToTopRouter({
    required this.child,
    this.duration = 500,
    this.curve = Curves.fastOutSlowIn,
    this.routeName,
  }) : super(
          transitionDuration: Duration(milliseconds: duration),
          pageBuilder: (ctx, a1, a2) {
            return child;
          },
          settings: RouteSettings(name: routeName),
          transitionsBuilder: (ctx, a1, a2, Widget child) {
            return SlideTransition(
              position: Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                  .animate(CurvedAnimation(parent: a1, curve: curve)),
              child: child,
            );
          },
        );
}
