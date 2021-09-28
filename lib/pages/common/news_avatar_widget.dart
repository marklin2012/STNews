import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';

class NewsAvatarWidget extends StatelessWidget {
  const NewsAvatarWidget({Key? key, required this.child, this.size = 32})
      : super(key: key);

  final Widget child;

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: ColorConfig.accentColor,
        height: size,
        width: size,
        child: child,
      ),
    );
  }
}
