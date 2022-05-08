import 'dart:convert';

import 'package:flutter/services.dart';

const List<String> pathes = [];

class Mock {
  static Future<Map> loadData(String path) async {
    Map res = {"message": "SUCCESS", "code": 1, "data": {}};
    final _json = await rootBundle.loadString('lib/mock/json/$path');
    res = json.decode(_json);
    return res;
  }
}
