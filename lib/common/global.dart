import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stnews/login/model/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences? preferences;
  static Profile profile = Profile();

  // 初始化全局信息，在App启动时执行
  static Future init() async {
    preferences = await SharedPreferences.getInstance();

    var _profile = preferences?.getString('profile');

    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  static saveProfile() {
    preferences
        ?.setString('profile', jsonEncode(profile.toJson()))
        .then((bool success) {
      debugPrint(success.toString());
    });
  }
}
