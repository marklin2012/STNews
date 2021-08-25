import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/person/person_notice/model/notice_model.dart';
import 'package:stnews/person/person_notice/platform_notice_page.dart';
import 'package:stnews/person/person_notice/subview/person_notice_cell.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonNoticePage extends StatefulWidget {
  const PersonNoticePage({Key? key}) : super(key: key);

  @override
  _PersonNoticePageState createState() => _PersonNoticePageState();
}

class _PersonNoticePageState extends State<PersonNoticePage> {
  late List _lists;

  @override
  void initState() {
    super.initState();
    _lists = [
      NoticeModel('0', '平台通知', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息', notices: 8),
      NoticeModel('1', '谁评论了我', DateTime.now().add(Duration(days: -1))),
      NoticeModel('2', '谁点赞了我', DateTime.now().add(Duration(days: -1))),
      NoticeModel('3', '端午活动', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息'),
      NoticeModel('4', '祝福你', DateTime(2021, 6, 23),
          subTitle: '文字信息', notices: 100),
    ];
  }

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
        title: Text('消息中心'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: STButton(
              type: STButtonType.text,
              text: '清除未读',
              textStyle:
                  TextStyle(fontSize: FONTSIZE17, fontWeight: FONTWEIGHT400),
              onTap: _deletUnRead,
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        child: ListView.builder(
            itemCount: _lists.length,
            itemBuilder: (context, index) {
              final model = _lists[index];
              return PersonNoticeCell(
                model: model,
                onTap: () {
                  _tapActions(model.id);
                },
              );
            }),
      ),
    );
  }

  void _deletUnRead() {}

  void _tapActions(String id) {
    debugPrint(id);
    if (id == '0') {
      // 平台通知
      STRouters.push(context, PlatformNoticePage());
    }
  }
}
