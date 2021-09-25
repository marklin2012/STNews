import 'package:flutter/material.dart';

class NewsAvatarWidget extends StatelessWidget {
  const NewsAvatarWidget({Key? key, required this.child, this.size = 32})
      : super(key: key);

  final Widget child;

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Theme.of(context).accentColor,
        height: size,
        width: size,
        child: child,
      ),
    );
  }
}
