import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class HomePostProvider extends ChangeNotifier {
  HomePostProvider({Key? key});

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  List<PostModel> _banners = [];
  List<PostModel> get banners => _banners;
  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool get isEmptyPosts => _posts.length == 0;

  Future<bool> initOrRefresh() async {
    _page = 1;

    ResultData bannerRes = await Api.getPostBanners();

    ResultData postRes = await Api.getPosts(page: _page, perpage: _perpage);
    if (bannerRes.success) {
      List _temps = bannerRes.data as List;
      _banners = _temps.map((e) => PostModel.fromJson(e)).toList();
    }
    if (postRes.success) {
      List _temps = postRes.data as List;
      _hasMore = STList.hasMore(_temps);
      _posts = _temps.map((e) => PostModel.fromJson(e)).toList();
    }
    notifyListeners();
    return Future.value(true);
  }

  Future<ResultRefreshData> loadMore() async {
    ResultRefreshData data;
    if (!_hasMore) {
      data = ResultRefreshData.noMore();
    } else {
      _page++;
      ResultData result = await Api.getPosts(page: _page, perpage: _perpage);
      if (result.success) {
        List _datas = result.data as List;
        _hasMore = STList.hasMore(_datas);
        for (Map<String, dynamic> item in _datas) {
          final _temp = PostModel.fromJson(item);
          _posts.add(_temp);
        }
        data = ResultRefreshData(success: true, hasMore: _hasMore);
      } else {
        data = ResultRefreshData.error();
      }
    }
    notifyListeners();
    return Future.value(data);
  }
}
