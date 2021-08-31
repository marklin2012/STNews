import 'package:flutter/material.dart';
import 'package:stnews/common/global.dart';
import 'package:stnews/login/model/profile.dart';
import 'package:stnews/login/model/user.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangeNotifier {
  User? get user => profile.user;

  bool? get isLogin => profile.isLogin;

  String? get token => profile.token;

  set user(User? user) {
    profile.user = user;
    notifyListeners();
  }

  set isLogin(bool? isLogin) {
    profile.isLogin = isLogin;
    notifyListeners();
  }
}
