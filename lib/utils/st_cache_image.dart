import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/image+.dart';

class STCaCheImage {
  static Widget loadingImage({
    String? imageUrl,
    Widget? errorW,
  }) {
    String _url = "http://via.placeholder.com/30x30";
    if (imageUrl != null && imageUrl.isNotEmpty) {
      _url = BaseUrl + imageUrl;
    }
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (context, imageProvider) {
        return NewsImage.defaultAvatar();
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        debugPrint('图片加载失败:' + error);
        return errorW ?? Icon(STIcons.commonly_user);
      },
    );
  }
}
