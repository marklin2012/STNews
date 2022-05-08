import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

typedef PhotoViewPageChanged = void Function(int index);

class NewsPhotoView extends StatefulWidget {
  const NewsPhotoView({
    Key? key,
    required this.galleryItems,
    this.defaultImage = 0,
    this.pageChanged,
    this.direction,
    this.decoration,
  }) : super(key: key);

  final List<String> galleryItems; // 图片列表

  final int defaultImage; // 默认第几张图

  final PhotoViewPageChanged? pageChanged; // 切换图片的回调

  final Axis? direction; // 图片查看方向

  final BoxDecoration? decoration; // 背景

  @override
  _NewsPhotoViewState createState() => _NewsPhotoViewState();
}

enum PhotoViewImageSource {
  imageSourceLocal,
  imageSourceNewwork,
}

class _NewsPhotoViewState extends State<NewsPhotoView> {
  late int _defaultSelected;
  late Axis _direction;
  late BoxDecoration _decoration;
  late PhotoViewImageSource _imageSource;

  @override
  void initState() {
    super.initState();
    _defaultSelected = widget.defaultImage;
    _direction = widget.direction ?? Axis.horizontal;
    _decoration = widget.decoration ?? BoxDecoration(color: Colors.transparent);
    _imageSource = PhotoViewImageSource.imageSourceLocal;
    if (widget.galleryItems.isNotEmpty) {
      final _temp = widget.galleryItems.first;
      if (STString.isPrefixHttp(_temp)) {
        _imageSource = PhotoViewImageSource.imageSourceNewwork;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorConfig.textFirColor,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).size.width / 4,
          bottom: MediaQuery.of(context).size.width / 4,
          child: Container(
            child: PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              scrollDirection: _direction,
              backgroundDecoration: _decoration,
              itemCount: widget.galleryItems.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: _setupImageProvider(index),
                  heroAttributes: PhotoViewHeroAttributes(
                      tag: NewsHeroTags.showPhotoImageTag +
                          widget.galleryItems[index]),
                );
              },
              pageController: PageController(initialPage: _defaultSelected),
              onPageChanged: (index) => setState(() {
                _defaultSelected = index;
                if (widget.pageChanged != null) {
                  widget.pageChanged!(_defaultSelected);
                }
              }),
            ),
          ),
        ),
        Positioned(
          left: 10,
          right: 20,
          top: MediaQuery.of(context).size.width / 4 - 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              STButton.icon(
                backgroundColor: Colors.transparent,
                size: STButtonSize.small,
                icon: Icon(
                  STIcons.commonly_close_outline,
                  size: 20,
                  color: ColorConfig.primaryColor,
                ),
                onTap: () {
                  STRouters.pop(context);
                },
              ),
              Text(
                '${_defaultSelected + 1}/${widget.galleryItems.length}',
                style: NewsTextStyle.style14NormalWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }

  ImageProvider _setupImageProvider(int index) {
    final url = widget.galleryItems[index];
    if (_imageSource == PhotoViewImageSource.imageSourceLocal) {
      return AssetImage(url);
    } else {
      return CachedNetworkImageProvider(url);
    }
  }
}
