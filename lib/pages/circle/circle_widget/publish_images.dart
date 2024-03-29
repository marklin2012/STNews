import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/pages/common/news_photo_view.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

class PublishImages extends StatefulWidget {
  static const publishImagesDebounceKey = '_publishImagesDebounceKey';
  const PublishImages({
    Key? key,
    this.sucImgCallBack,
    this.backgroundColor,
    this.padding,
    this.images,
    this.crossAxisCount = 4,
    this.imageSize = 80,
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
  }) : super(key: key);

  final Function(List<String>)? sucImgCallBack;

  final Color? backgroundColor;

  final EdgeInsets? padding;

  final List<String>? images;

  final int crossAxisCount;

  final double imageSize;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  @override
  _PublishImagesState createState() => _PublishImagesState();
}

class _PublishImagesState extends State<PublishImages> {
  late List<String> _images;
  late Color _backgroundColor;
  late EdgeInsets _padding;

  @override
  void initState() {
    super.initState();
    _images = widget.images ?? [];
    _backgroundColor = widget.backgroundColor ?? ColorConfig.backgroundColor;
    _padding = widget.padding ?? EdgeInsets.all(16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      height: _getGridViewHeight(),
      padding: _padding,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
        ),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            return _getAddBtn();
          }
          final _galleryItem = STString.addPrefixHttp(_images[index]) ?? '';
          return GestureDetector(
            onTap: () {
              STDebounce().start(
                key: PublishImages.publishImagesDebounceKey,
                func: () {
                  final _galleryItems = _images
                      .map((e) => STString.addPrefixHttp(e) ?? '')
                      .toList();
                  STRouters.push(
                    context,
                    NewsPhotoView(
                        galleryItems: _galleryItems, defaultImage: index),
                  );
                },
                time: 200,
              );
            },
            child: GestureDetector(
              onLongPress: () {
                _showDeletePhoto(index);
              },
              child: Container(
                height: widget.imageSize,
                width: widget.imageSize,
                child: Hero(
                  tag: NewsHeroTags.showPhotoImageTag + _galleryItem,
                  child: STCaCheImage.loadingImage(
                    imageUrl: _images[index],
                    placeholder: STCaCheImage.publishPlaceHolder(),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _images.length + 1,
      ),
    );
  }

  double _getGridViewHeight() {
    double _rows = (_images.length + 1.0) / widget.crossAxisCount;
    int _ceil = _rows.ceil();
    final _height = _ceil * (widget.imageSize + widget.mainAxisSpacing) + 30;
    return _height;
  }

  Widget _getAddBtn() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        STDebounce().start(
          key: PublishImages.publishImagesDebounceKey,
          func: () {
            FocusScope.of(context).requestFocus(FocusNode());
            NewsImagePicker.showPicker(
              firContent: '从相册选择图片',
              secContent: '拍照',
              context: context,
              galleryTap: _openGallery,
              cameraTap: _useCamera,
            );
          },
        );
      },
      child: Image(
        image: AssetImage('assets/images/default_add_picture.png'),
        width: widget.imageSize,
        height: widget.imageSize,
      ),
    );
  }

  // 长按删除
  void _showDeletePhoto(int index) {
    STDebounce().start(
      key: PublishImages.publishImagesDebounceKey,
      func: () {
        FocusScope.of(context).requestFocus(FocusNode());
        NewsImagePicker.showPicker(
          context: context,
          firContent: '删除',
          galleryTap: () {
            STRouters.pop(context);
            _images.removeAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  /// 拍照
  void _useCamera() async {
    STRouters.pop(context);
    final _image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (_image == null) return;
    _uploadFile(_image.path);
  }

  /// 相册
  void _openGallery() async {
    STRouters.pop(context);
    final _temps = await ImagePicker().pickMultiImage(
      imageQuality: 100,
    );
    if (_temps != null) {
      for (XFile _temp in _temps) {
        _uploadFile(_temp.path);
      }
    }
  }

  void _uploadFile(String path) async {
    FormData formData = new FormData.fromMap({
      'files': [
        MultipartFile.fromFileSync(path,
            contentType: MediaType.parse('image/jpeg')),
      ],
    });
    Api.uploadFile(data: formData).then((result) {
      if (result.success) {
        _images.add(result.data['imgUrl']);
        if (widget.sucImgCallBack != null) {
          widget.sucImgCallBack!(_images);
        }
        setState(() {});
      }
    });
  }
}
