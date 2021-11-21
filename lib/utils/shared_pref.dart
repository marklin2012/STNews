import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const circleSearchHistoryPrefKey = 'circleSearchHistoryPrefKey';

  static Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear().then((success) {
      if (success) {}
      return true;
    });
  }

  static Future<bool> saveUsers(Map<String, dynamic>? user) async {
    if (user == null) return Future.value(false);
    String jsonStringUser = jsonEncode(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('user', jsonStringUser);
  }

  static Future<Map<String, dynamic>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonStringUser = prefs.getString('user');
    if (jsonStringUser != null) {
      Map<String, dynamic> user = json.decode(jsonStringUser);
      return user;
    } else {
      throw new Exception('获取用户数据失败');
    }
  }

  static Future<List<String>> getCircleSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(SharedPref.circleSearchHistoryPrefKey) ?? [];
  }

  static Future<bool> saveCircleSearchHistory(String value) async {
    List<String>? _historys = await SharedPref.getCircleSearchHistory();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_historys.isNotEmpty) {
      if (_historys.contains(value)) {
        _historys.remove(value);
      }
      _historys.insert(0, value);
      return prefs.setStringList(
          SharedPref.circleSearchHistoryPrefKey, _historys);
    } else {
      return prefs
          .setStringList(SharedPref.circleSearchHistoryPrefKey, [value]);
    }
  }

  static Future<bool> clearCircleSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(SharedPref.circleSearchHistoryPrefKey);
  }
}
