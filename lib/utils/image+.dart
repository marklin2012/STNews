import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stnews/utils/string+.dart';

class NewsImage {
  static Image defaultAvatar({
    double height = 36,
  }) {
    return Image(
      image: AssetImage('assets/images/default_avatar.png'),
      height: height,
    );
  }

  static Image defaultCircle({double height = 100}) {
    return Image(
      image: AssetImage('assets/images/default_empty.png'),
      height: height,
      fit: BoxFit.fitWidth,
    );
  }

  static Widget networkImage({
    String? path,
    double? width,
    double? height,
    Widget? defaultChild,
  }) {
    if (path == null) {
      return Center(child: defaultChild);
    }
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageUrl: STString.addPrefixHttp(path) ?? '',
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        child: Center(
          child: defaultChild,
        ),
      ),
    );
  }
}
