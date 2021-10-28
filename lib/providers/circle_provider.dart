import 'package:flutter/material.dart';
import 'package:stnews/models/circle_model.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/providers/user_provider.dart';

class CircleProvider extends ChangeNotifier {
  CircleProvider({Key? key});

  List<CircleModel> _lists = [];
  List<CircleModel> get lists => _lists;

  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool get isEmpty => _lists.length == 0;

  Future<bool> initData() {
    _page = 1;

    _lists = [
      CircleModel(
        id: '00000000',
        title: '香港攻略，一日游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000001',
        title: '香港攻略，两日一晚游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000002',
        title: '香港攻略，三日两晚游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000003',
        title: '香港攻略，一周游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000004',
        title: '香港攻略，一月游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000005',
        title: '香港攻略，一周游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
      CircleModel(
        id: '00000006',
        title: '香港攻略，一月游可以这样玩！',
        user: UserProvider.shared.user,
        isUserFavourite: false,
        favouriteCount: 12,
      ),
    ];

    notifyListeners();

    return Future.value(true);
  }
}
