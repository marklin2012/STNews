import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/person_notice_cell.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonNoticePage extends StatefulWidget {
  const PersonNoticePage({Key? key}) : super(key: key);

  @override
  _PersonNoticePageState createState() => _PersonNoticePageState();
}

class _PersonNoticePageState extends State<PersonNoticePage> {
  List _lists = [];

  bool get isEmpty => _lists.isEmpty;

  @override
  void initState() {
    super.initState();
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
              textStyle: isEmpty
                  ? NewsTextStyle.style17NormalFourGrey
                  : NewsTextStyle.style17NormalBlack,
              onTap: _deletUnRead,
            ),
          ),
        ],
      ),
      body: _getSubWidget(),
    );
  }

  Widget _getSubWidget() {
    if (isEmpty) {
      return EmptyViewWidget(
        fixTop: 162.0,
        imageBGSize: 100.0,
        content: '暂无任何消息哦～',
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 24.0),
      child: ListView.builder(
          itemCount: _lists.length,
          itemBuilder: (context, index) {
            final model = _lists[index];
            return PersonNoticeCell(
              model: model,
              onTap: () {
                // _tapActions(model.id);
              },
            );
          }),
    );
  }

  void _deletUnRead() {}

  // void _tapActions(String id) {
  //   debugPrint(id);
  //   if (id == '0') {
  //     // 平台通知
  //     STRouters.push(context, PlatformNoticePage());
  //   }
  // }
}
