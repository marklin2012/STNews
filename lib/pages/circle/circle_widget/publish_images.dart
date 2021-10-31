import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class PublishImages extends StatefulWidget {
  static const publishImagesDebounceKey = '_publishImagesDebounceKey';
  const PublishImages({Key? key, this.sucImgCallBack}) : super(key: key);

  final Function(List<String>)? sucImgCallBack;

  @override
  _PublishImagesState createState() => _PublishImagesState();
}

class _PublishImagesState extends State<PublishImages> {
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConfig.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      height: _getGridViewHeight(),
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            return _getAddBtn();
          }
          return Container(
            height: 80,
            width: 80,
            child: STCaCheImage.loadingImage(imageUrl: _images[index]),
          );
        },
        itemCount: _images.length + 1,
      ),
    );
  }

  double _getGridViewHeight() {
    double _rows = (_images.length + 1.0) / 4.0;
    int _ceil = _rows.ceil();
    final _height = _ceil * 85.0 + 30;
    return _height;
  }

  Widget _getAddBtn() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        STDebounce().start(
          key: PublishImages.publishImagesDebounceKey,
          func: () {
            NewsImagePicker.showPicker(
              context: context,
              galleryTap: _openGallery,
              cameraTap: _useCamera,
            );
          },
        );
      },
      child: Image(
        image: AssetImage('assets/images/default_add_picture.png'),
        width: 80,
        height: 80,
      ),
    );
  }

  /// 拍照
  void _useCamera() async {
    STRouters.pop(context);
    final _image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (_image == null) return;
    _uploadFile(_image.path);
  }

  /// 相册
  void _openGallery() async {
    STRouters.pop(context);
    final _temps = await ImagePicker()
        .pickMultiImage(maxHeight: 80, maxWidth: 80, imageQuality: 9);
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