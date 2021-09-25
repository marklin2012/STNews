import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
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

  static Future<bool> saveUsers(Map<String, dynamic> user) async {
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
}
