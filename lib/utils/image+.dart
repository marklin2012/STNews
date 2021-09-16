import 'package:flutter/material.dart';

class NewsImage {
  static Image defaultAvatar({
    double height = 36,
  }) {
    return Image(
      image: AssetImage('assets/images/default_avatar.png'),
      height: height,
    );
  }
}
