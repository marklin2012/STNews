import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/person/person_info/change_info_page.dart';
import 'package:stnews/pages/person/person_widgets/person_tile.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  List<Map> _datas = [
    {'title': '头像', 'isHead': ''},
    {'title': '昵称', 'isSubTitle': ''},
    {'title': '性别', 'isSubTitle': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
        title: Text('个人信息'),
      ),
      body: Container(
        height: 52.0 * _datas.length - 4.0,
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemExtent: 52.0,
              itemCount: _datas.length,
              itemBuilder: (context, index) {
                final _map = _datas[index];
                switch (index) {
                  case 0:
                    _map['isHead'] = userProvider.user.avatar ?? '';
                    break;
                  case 1:
                    _map['isSubTitle'] = userProvider.user.nickname;
                    break;
                  case 2:
                    String _sex = '';
                    if (userProvider.user.sex == 1) {
                      _sex = '男';
                    } else if (userProvider.user.sex == 2) {
                      _sex = '女';
                    }
                    _map['isSubTitle'] = _sex;
                    break;
                  default:
                }
                return PersonTile(
                  data: _map,
                  onTap: () {
                    _goNextPage(index);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _goNextPage(int index) {
    switch (index) {
      case 0:
        NewsImagePicker.showPicker(
          context: context,
          galleryTap: _openGallery,
          cameraTap: _useCamera,
        );
        break;
      case 1:
        // 修改昵称
        STRouters.push(
          context,
          ChangeInfoPage(isChangeSex: false),
          direction: STRoutersDirection.rightToLeft,
        );
        break;
      case 2:
        // 修改性别
        STRouters.push(
          context,
          ChangeInfoPage(isChangeSex: true),
          direction: STRoutersDirection.rightToLeft,
        );
        break;

      default:
    }
  }

  /// 拍照
  void _useCamera() async {
    final _image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    _uploadImage(_image);
  }

  /// 相册
  void _openGallery() async {
    final _image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    _uploadImage(_image);
  }

  /// 上传图片
  void _uploadImage(XFile? image) async {
    if (image == null) {
      return;
    }
    String path = image.path;
    FormData formData = new FormData.fromMap({
      'files': [
        MultipartFile.fromFileSync(path,
            contentType: MediaType.parse('image/jpeg')),
      ],
    });
    NewsLoading.start(context);
    // 上传图片
    ResultData result1 = await Api.uploadFile(data: formData);
    ResultData? result2;
    String? imageUrl;
    if (result1.success) {
      imageUrl = result1.data['imgUrl'];
      result2 = await Api.updateUserInfo(avatar: imageUrl);
    }
    NewsLoading.stop();
    if (result2?.success ?? false) {
      UserProvider.shared.changeUser(avatar: imageUrl);
    }
    STRouters.pop(context);
  }
}
