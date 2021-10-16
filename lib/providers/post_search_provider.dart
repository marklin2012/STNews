import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class PostSearchProvider extends ChangeNotifier {
  PostSearchProvider({Key? key});

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool get isEmpty => _posts.length == 0;

  Future search({String? key}) async {
    _page = 1;
    ResultData result =
        await Api.search(page: _page, perpage: _perpage, key: key);
    if (result.success) {
      List _temps = result.data['posts'] as List;
      _hasMore = STList.hasMore(_temps);
      _posts = _temps.map((e) => PostModel.fromJson(e)).toList();
    }
    notifyListeners();
    return Future.value(true);
  }
}
