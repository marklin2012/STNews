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

  List<MomentModel> _seachDiscovers = [];
  List<MomentModel> get seachDiscovers => _seachDiscovers;
  bool get hasDiscovers => _seachDiscovers.isNotEmpty;

  set seaResults(List<MomentModel> discovers) {
    _seachDiscovers = discovers;

    notifyListeners();
  }

  List<MomentModel> _searchRecords = [];
  List<MomentModel> get searchRecords => _searchRecords;
  bool get hasRecords => _searchRecords.isNotEmpty;

  void cleanSearchRecoreds() {
    _searchRecords = [];
    notifyListeners();
  }

  Future<bool> searchKey({required String key}) async {
    ResultData result = await Api.searchMoment(key: key);
    if (result.success && result.data['moments'] is List) {
      List temps = result.data['moments'] as List;
      _searchRecords = temps.map((e) => MomentModel.fromJson(e)).toList();
      notifyListeners();
    }
    return Future.value(true);
  }
}
