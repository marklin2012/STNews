import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stnews/utils/string+.dart';

class NewsImage {
  static const defaultAvatarPath = 'assets/images/default_avatar.png';

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
      fit: BoxFit.fitHeight,
    );
  }

  static Widget networkImage({
    String? path,
    double? width,
    double? height,
    Widget? defaultChild,
    BorderRadius borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path == null) {
      return Center(child: defaultChild);
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: STString.addPrefixHttp(path) ?? '',
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          child: Center(
            child: defaultChild,
          ),
        ),
      ),
    );
  }
}
