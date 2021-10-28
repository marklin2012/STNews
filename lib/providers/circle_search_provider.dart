import 'package:flutter/material.dart';
import 'package:stnews/utils/shared_pref.dart';

class CircleSearchProvider extends ChangeNotifier {
  CircleSearchProvider({Key? key});

  List<String> _historys = [];
  List<String> get historys => _historys;

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

  List<String> _seaResults = [];
  List<String> get seaResults => _seaResults;
  bool get hasResults => _seaResults.isNotEmpty;

  set seaResults(List<String> results) {
    _seaResults = results;

    notifyListeners();
  }
}
