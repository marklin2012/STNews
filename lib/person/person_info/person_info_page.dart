import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/person/person_info/change_info_page.dart';
import 'package:stnews/person/subview/news_action_sheet.dart';
import 'package:stnews/person/subview/person_tile.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  List<Map> _datas = [
    {'title': '头像', 'isHead': ''},
    {'title': '昵称', 'isSubTitle': '特仑苏纯牛奶'},
    {'title': '性别', 'isSubTitle': '女'},
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
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemExtent: 52.0,
          itemCount: _datas.length,
          itemBuilder: (context, index) {
            final _map = _datas[index];
            return Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(bottom: 4.0),
              child: PersonTile(
                data: _map,
                onTap: () {
                  _goNextPage(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _goNextPage(int index) {
    switch (index) {
      case 0:
        // 弹窗
        NewsActionSheet.show(
          context: context,
          actions: [
            NewsActionSheetAction(
              onPressed: _openGallery,
              child: Text(
                '从相册选择图片',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: FONTSIZE16,
                  fontWeight: FONTWEIGHT400,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEFF3F9))),
              ),
            ),
            NewsActionSheetAction(
                onPressed: _useCamera,
                child: Text(
                  '拍照',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: FONTSIZE16,
                    fontWeight: FONTWEIGHT400,
                  ),
                )),
            NewsActionSheetAction(
                onPressed: () {
                  STRouters.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: FONTSIZE18,
                      fontWeight: FONTWEIGHT500,
                    ),
                  ),
                )),
          ],
        );
        break;
      case 1:
        // 修改昵称
        STRouters.push(context, ChangeInfoPage(isChangeSex: false));
        break;
      case 2:
        // 修改性别
        STRouters.push(context, ChangeInfoPage(isChangeSex: true));
        break;

      default:
    }
  }

  /// 拍照
  void _useCamera() async {
    final _image = await ImagePicker().pickImage(source: ImageSource.camera);
  }

  /// 相册
  void _openGallery() async {
    final _image = await ImagePicker().pickImage(source: ImageSource.camera);
  }
}
