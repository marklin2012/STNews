import 'package:flutter/material.dart';

import 'package:saturn/saturn.dart';
import 'package:stnews/login/webview_page.dart';
import 'package:stnews/person/person_notice/model/notice_model.dart';
import 'package:stnews/person/person_notice/subview/person_notice_cell.dart';
import 'package:stnews/utils/st_routers.dart';

class PlatformNoticePage extends StatefulWidget {
  const PlatformNoticePage({Key? key}) : super(key: key);

  @override
  _PlatformNoticePageState createState() => _PlatformNoticePageState();
}

class _PlatformNoticePageState extends State<PlatformNoticePage> {
  late List _lists;

  @override
  void initState() {
    super.initState();
    _lists = [
      NoticeModel('0', '协议更新通知', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息'),
      NoticeModel('1', '平台通知', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息'),
      NoticeModel('2', '平台通知', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息'),
      NoticeModel('3', '平台通知', DateTime.now().add(Duration(days: -1)),
          subTitle: '文字信息'),
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
        title: Text('平台通知'),
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

  void _tapActions(String id) {
    if (id == '0') {
      // 协议更新通知
      STRouters.push(context, WebViewPage(title: '协议更新通知'));
    }
  }
}
