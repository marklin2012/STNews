import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/notice_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/pages/person/person_widgets/person_notice_cell.dart';
import 'package:stnews/providers/notice_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/utils+.dart';

class PersonNoticePage extends StatefulWidget {
  const PersonNoticePage({Key? key}) : super(key: key);

  @override
  _PersonNoticePageState createState() => _PersonNoticePageState();
}

class _PersonNoticePageState extends State<PersonNoticePage> {
  NoticeProvider get noticeProvider =>
      Provider.of<NoticeProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    noticeProvider.getNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NewsPopBtn.popBtn(context),
        title: Text('消息中心'),
        actions: [
          Consumer<NoticeProvider>(builder: (context, noticeProvider, _) {
            return Container(
              padding: EdgeInsets.only(right: 10.0),
              child: STButton(
                type: STButtonType.text,
                disabled: noticeProvider.isAllReaded,
                text: '清除未读',
                textStyle: noticeProvider.isAllReaded
                    ? NewsTextStyle.style17NormalFourGrey
                    : NewsTextStyle.style17NormalBlack,
                onTap: _deletUnRead,
              ),
            );
          }),
        ],
      ),
      body: _getSubWidget(),
    );
  }

  Widget _getSubWidget() {
    return Consumer<NoticeProvider>(builder: (context, noticeP, _) {
      if (!noticeP.hasData) {
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
            itemCount: noticeP.notices.length,
            itemBuilder: (context, index) {
              NoticeModel model = noticeP.notices[index];
              return PersonNoticeCell(
                model: model,
                onTap: () {
                  _tapActions(index);
                },
              );
            },
          ),
        ),
      );
    });
  }

  Future _onRefresh() async {
    NewsLoading.start(context);
    await noticeProvider.getNotices();
    NewsLoading.stop();
  }

  Future<ResultRefreshData> _onLoad() async {
    NewsLoading.start(context);
    ResultRefreshData data = await noticeProvider.loadMoreNotices();
    NewsLoading.stop();
    return data;
  }

  Future _deletUnRead() async {
    if (noticeProvider.isAllReaded) return;
    NewsLoading.start(context);
    await noticeProvider.deletUnRead();
    NewsLoading.stop();
  }

  void _tapActions(int index) async {
    if (noticeProvider.notices.length > index) {
      NewsLoading.start(context);
      await noticeProvider.readOne(index);
      NewsLoading.stop();
      NoticeModel model = noticeProvider.notices[index];
      if (model.type == NotifyType.sysType) {
        STRouters.push(
          context,
          WebViewPage(
            title: model.announceID?.title,
            content: model.announceID?.content ?? null,
          ),
        );
      }
    }
  }
}
