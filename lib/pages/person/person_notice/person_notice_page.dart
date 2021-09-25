import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/notice_model.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/person_notice_cell.dart';
import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonNoticePage extends StatefulWidget {
  const PersonNoticePage({Key? key}) : super(key: key);

  @override
  _PersonNoticePageState createState() => _PersonNoticePageState();
}

class _PersonNoticePageState extends State<PersonNoticePage> {
  List<NoticeModel> _lists = [];

  bool get isEmpty => _lists.isEmpty;

  bool _isAllReaded = true;

  late int _page;
  late int _perpage;
  bool _hasMore = false;

  @override
  void initState() {
    _page = 1;
    _perpage = NewsPerpage.finalPerPage;
    super.initState();
    _getNotiLists(true);
    _getAllReaded();
  }

  void _getNotiLists(bool isFirst) {
    if (!isFirst) NewsLoading.start(context);
    Api.getNotifyList(page: _page, perpage: _perpage).then((result) {
      if (result.success) {
        List _temps = result.data['noti'] as List;
        _hasMore = _temps.isNotEmpty;
        if (isFirst) {
          _lists = _temps.map((e) => NoticeModel.fromJson(e)).toList();
        } else {
          for (Map<String, dynamic> temp in _temps) {
            NoticeModel model = NoticeModel.fromJson(temp);
            _lists.add(model);
          }
        }
        _getAllReaded();
        setState(() {});
      }
      if (!isFirst) NewsLoading.stop();
    });
  }

  void _getAllReaded() {
    for (NoticeModel model in _lists) {
      if (model.isRead == false) {
        _isAllReaded = false;
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
              disabled: _isAllReaded,
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
      padding: EdgeInsets.only(top: 24.0),
      child: NewsEasyRefresh(
        hasHeader: true,
        hasFooter: true,
        onRefresh: _onRefresh,
        onLoad: _onLoad,
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
          },
        ),
      ),
    );
  }

  Future _onRefresh() async {
    _page = 1;
    _lists.clear();
    _getNotiLists(false);
  }

  Future _onLoad() async {
    if (!_hasMore) return;
    _page++;
    _getNotiLists(false);
  }

  // void _deletUnRead() {
  //   if (isEmpty) return;
  //   NewsLoading.start(context);
  //   Api.setNotifyReaded().then((result) {
  //     NewsLoading.stop();
  //     if (result.success) {
  //       STToast.show(context: context, message: '已标记全部已读');
  //     } else {
  //       STToast.show(context: context, message: result.message);
  //     }
  //   });
  // }

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
