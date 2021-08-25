import 'package:flutter/material.dart';

class STRouters {
  static Future push(BuildContext context, Widget widget,
      {String? routeName}) async {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext buildContext) => widget,
        settings: RouteSettings(name: routeName)));
  }

  static Future pop(BuildContext context) async {
    return Navigator.of(context).pop();
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

const FONTWEIGHT400 = FontWeight.w400;
const FONTWEIGHT500 = FontWeight.w500;

const FONTSIZE12 = 12.0;
const FONTSIZE14 = 14.0;
const FONTSIZE16 = 16.0;
const FONTSIZE17 = 17.0;
const FONTSIZE18 = 18.0;
const FONTSIZE28 = 28.0;
