import 'package:flutter/material.dart';

class STRouters {
  static Future push(BuildContext context, Widget widget,
      {String? routeName}) async {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext buildContext) => widget,
        settings: RouteSettings(name: routeName)));
  }

  static Future pop(BuildContext context) async {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
      return Future.value(true);
    }
    return Future.value(false);
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
