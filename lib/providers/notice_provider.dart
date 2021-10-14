import 'package:flutter/material.dart';
import 'package:stnews/models/notice_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class NoticeProvider extends ChangeNotifier {
  NoticeProvider({Key? key});

  List<NoticeModel> _notices = [];

  List<NoticeModel> get notices => _notices;

  int _page = 1;

  int _perpage = NewsPerpage.finalPerPage;

  bool _isAllReaded = false;

  bool get isAllReaded => _isAllReaded;

  bool get hasData => _notices.length > 0;

  bool _hasMore = false;

  bool get hasMore => _hasMore;

  Future getNotices() async {
    _page = 1;
    ResultData result = await Api.getNotifyList(page: _page, perpage: _perpage);
    if (result.success) {
      List _temps = result.data['noti'] as List;
      _hasMore = STList.hasMore(_temps);
      _notices = _temps.map((e) => NoticeModel.fromJson(e)).toList();
      _getAllReaded();
      notifyListeners();
    }
  }

  Future<ResultRefreshData> loadMoreNotices() async {
    if (!_hasMore) return Future.value(ResultRefreshData.noMore());
    _page++;
    ResultData result = await Api.getNotifyList(page: _page, perpage: _perpage);
    ResultRefreshData data = ResultRefreshData.normal();
    if (result.success) {
      List _temps = result.data['noti'] as List;
      _hasMore = STList.hasMore(_temps);
      for (Map<String, dynamic> temp in _temps) {
        NoticeModel model = NoticeModel.fromJson(temp);
        _notices.add(model);
      }
      _getAllReaded();
      data = ResultRefreshData(success: true, hasMore: _hasMore);
    } else {
      data = ResultRefreshData.error();
    }
    notifyListeners();
    return Future.value(data);
  }

  void _getAllReaded() {
    for (NoticeModel model in _notices) {
      if (model.isRead == false) {
        _isAllReaded = false;
        break;
      }
    }
  }

  Future deletUnRead() async {
    if (_isAllReaded) return;
    ResultData result = await Api.setNotifyReaded();
    if (result.success) {
      _isAllReaded = true;
      notifyListeners();
    }
  }

  Future readOne(int index) async {
    if (_notices.length > index) {
      NoticeModel model = _notices[index];
      ResultData result = await Api.setNotifyReaded(id: model.id);
      if (result.success) {
        model.isRead = true;
        notifyListeners();
      }
    }
  }
}
