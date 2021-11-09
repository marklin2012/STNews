import 'package:flutter/material.dart';
import 'package:stnews/models/moment_model.dart';
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

  Future searchHotMoment() async {
    ResultData result = await Api.searchMomentHot();
    if (result.success) {
      if (result.data['hotKeys'] is List) {
        final temps = result.data['hotKeys'] as List;
        _seachDiscovers = temps.map((e) => e.toString()).toList();
      }
      notifyListeners();
    }
  }

  List<MomentModel> _searchRecords = [];
  List<MomentModel> get searchRecords => _searchRecords;
  bool get hasRecords => _searchRecords.isNotEmpty;

  void cleanSearchRecoreds() {
    _searchRecords = [];
    notifyListeners();
  }

  Future searchKey({required String key}) async {
    ResultData result = await Api.searchMoment(key: key);
    if (result.success && result.data['moments'] is List) {
      List temps = result.data['moments'] as List;
      _searchRecords = temps.map((e) => MomentModel.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
