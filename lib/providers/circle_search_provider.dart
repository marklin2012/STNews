import 'package:flutter/material.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/shared_pref.dart';

class CircleSearchProvider extends ChangeNotifier {
  CircleSearchProvider({Key? key});

  List<String> _historys = [];
  List<String> get historys => _historys;
  bool get isEmpty => _historys.isEmpty;

  set historys(List<String> historys) {
    _historys = historys;

    notifyListeners();
  }

  /// 获取缓存的历史记录
  void getHistorys() async {
    historys = await SharedPref.getCircleSearchHistory();
  }

  /// 清空缓存的历史记录
  void cleanHistorys() async {
    await SharedPref.clearCircleSearchHistory();
    historys = [];
  }

  List<String> _seachDiscovers = [];
  List<String> get seachDiscovers => _seachDiscovers;
  bool get hasDiscovers => _seachDiscovers.isNotEmpty;

  set seaResults(List<String> discovers) {
    _seachDiscovers = discovers;

    notifyListeners();
  }

  List<String> _searchRecords = [];
  List<String> get searchRecords => _searchRecords;
  bool get hasRecords => _searchRecords.isNotEmpty;

  Future<bool> searchKey({required String key}) async {
    ResultData result = await Api.searchMoment(key: key);
    if (result.success) {
      _searchRecords = result.data;
      notifyListeners();
    }
    return Future.value(true);
  }
}
