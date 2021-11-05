import 'package:flutter/material.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class CircleProvider extends ChangeNotifier {
  CircleProvider({Key? key});

  List<MomentModel> _lists = [];
  List<MomentModel> get lists => _lists;

  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool get isEmpty => _lists.length == 0;

  Future<bool> initData() async {
    _page = 1;

    ResultData result = await Api.getMomentList(page: _page, perpage: _perpage);
    if (result.success && result.data is List) {
      final _temps = result.data as List;
      _hasMore = STList.hasMore(_temps);
      _lists = _temps.map((e) => MomentModel.fromJson(e)).toList();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<ResultRefreshData> loadMore() async {
    ResultRefreshData data;
    if (!_hasMore) return Future.value(ResultRefreshData.noMore());
    _page++;
    ResultData result = await Api.getMomentList(page: _page, perpage: _perpage);
    if (result.success) {
      final _temps = result.data as List;
      _hasMore = STList.hasMore(_temps);
      for (Map<String, dynamic> item in _temps) {
        final _temp = MomentModel.fromJson(item);
        _lists.add(_temp);
      }
      data = ResultRefreshData(success: true, hasMore: _hasMore);
    } else {
      data = ResultRefreshData.error();
    }
    notifyListeners();
    return Future.value(data);
  }

  /// 点赞或取消点赞圈子
  Future<bool> thumbupMoment({int? index, bool? isThumbup}) async {
    if (index == null) return Future.value(false);
    MomentModel moment = _lists[index];
    bool _isThumbup = isThumbup ?? false;
    ResultData result =
        await Api.changeMomentThumbup(moment: moment.id!, status: !_isThumbup);
    if (result.success) {
      _isThumbup = !_isThumbup;
      moment.isThumbuped = _isThumbup;
      if (_isThumbup) {
        moment.thumbUpCount = (moment.thumbUpCount ?? 0) + 1;
      } else {
        moment.thumbUpCount = moment.thumbUpCount! - 1;
      }
      notifyListeners();
    }
    return Future.value(_isThumbup);
  }
}
