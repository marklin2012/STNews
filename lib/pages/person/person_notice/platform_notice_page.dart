import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';

import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/pages/person/person_widgets/person_notice_cell.dart';
import 'package:stnews/utils/st_routers.dart';

class PlatformNoticePage extends StatefulWidget {
  const PlatformNoticePage({Key? key}) : super(key: key);

  @override
  _PlatformNoticePageState createState() => _PlatformNoticePageState();
}

class _PlatformNoticePageState extends State<PlatformNoticePage> {
  List _lists = [];

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
        title: Text('平台通知'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_lists.isEmpty) {
      return EmptyViewWidget();
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
                _tapActions(model.id);
              },
            );
          }),
    );
  }

  void _tapActions(String id) {
    if (id == '0') {
      // 协议更新通知
      STRouters.push(context, WebViewPage(title: '协议更新通知'));
    }
  }
}
