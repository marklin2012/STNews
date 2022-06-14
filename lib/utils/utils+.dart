import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';

class NewsBoxShadow {
  static get goodsShadaw => [
        BoxShadow(
          color: Color(0x0C000000),
          offset: Offset.zero,
          blurRadius: 6,
        ),
      ];
}

class NewsPopBtn {
  static popBtn(
    BuildContext context, {
    Color iconColor: Colors.black,
    Color bgColor: Colors.transparent,
    double size: 24,
  }) {
    return STButton.icon(
      icon: Icon(
        STIcons.direction_leftoutlined,
        size: size,
        color: iconColor,
      ),
      backgroundColor: bgColor,
      onTap: () {
        STRouters.pop(context);
      },
    );
  }
}
