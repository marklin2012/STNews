import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/string+.dart';

class STCaCheImage {
  static Widget loadingImage({
    String? imageUrl,
    Widget? errorW,
  }) {
    if (imageUrl == null || imageUrl.length == 0)
      return NewsImage.defaultAvatar();
    String _url = "http://via.placeholder.com/30x30";
    if (imageUrl.isNotEmpty) {
      _url = STString.addPrefixHttp(imageUrl)!;
    }
    return CachedNetworkImage(
      imageUrl: _url,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        return errorW ?? Icon(STIcons.commonly_user);
      },
    );
  }
}
