import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/notice_model.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/person_notice_cell.dart';
import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonNoticePage extends StatefulWidget {
  const PersonNoticePage({Key? key, required this.notices}) : super(key: key);

  final List<NoticeModel> notices;

  @override
  _PersonNoticePageState createState() => _PersonNoticePageState();
}

class _PersonNoticePageState extends State<PersonNoticePage> {
  List<NoticeModel> _lists = [];

  bool get isEmpty => _lists.isEmpty;

  bool _btnDisabled = true;

  @override
  void initState() {
    super.initState();
    _lists = widget.notices;
    _getAllReaded();
  }

  void _getAllReaded() {
    for (NoticeModel model in _lists) {
      if (model.isRead == false) {
        _btnDisabled = false;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAllReaded();
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
              disabled: _btnDisabled,
              text: '清除未读',
              textStyle: isEmpty
                  ? NewsTextStyle.style17NormalFourGrey
                  : NewsTextStyle.style17NormalBlack,
              // onTap: _deletUnRead,
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
            NoticeModel model = _lists[index];
            return PersonNoticeCell(
              model: model,
              onTap: () {
                _tapActions(model);
              },
            );
          }),
    );
  }

  void _deletUnRead() {
    if (isEmpty) return;
    NewsLoading.start(context);
    Api.setNotifyReaded().then((result) {
      NewsLoading.stop();
      if (result.success) {
        STToast.show(context: context, message: '已标记全部已读');
      } else {
        STToast.show(context: context, message: result.message);
      }
    });
  }

  void _tapActions(NoticeModel model) {
    if (model.isRead != null && !model.isRead!) {
      Api.setNotifyReaded(id: model.id).then((result) {
        if (result.success) {
          model.isRead = true;
          setState(() {});
        }
      });
    }
    if (model.type == NotifyType.sysType) {
      STRouters.push(
        context,
        WebViewPage(
          title: model.announceID?.title,
        ),
      );
    }
  }
}
