import 'package:flutter/material.dart';

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
}

class BlankPutKeyborad extends StatelessWidget {
  const BlankPutKeyborad({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
