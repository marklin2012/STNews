import 'package:flutter/material.dart';
import 'package:stnews/login/model/user_model.dart';
import 'package:stnews/sharedpreferences/shared_pref.dart';

class UserManager extends ChangeNotifier {
  UserModel _userModel = UserModel.fromJson({});

  UserModel get user => _userModel;

  static UserManager? _shared;

  static UserManager? get shared => UserManager._shardManager();

  static UserManager? _shardManager() {
    _shared = UserManager._();
    return _shared;
  }

  UserManager._() {
    SharedPref.getToken().then((token) {
      if (token != null) {
        SharedPref.getUsers().then((localUser) {
          _userModel = UserModel.fromJson(localUser);
        });
      }
    });
  }

  set user(UserModel? userModel) {
    if (userModel != null) {
      _userModel = userModel;
      notifyListeners();
    }
  }

  // 更新用户资料
  Future<bool?> changeUser({
    String? username,
    String? avatar,
    String? nickname,
    int? sex,
    String? mobile,
    String? email,
    int? followers,
    int? favourites,
  }) async {
    if (username != null) {
      _userModel.username = username;
    }

    if (avatar != null) {
      _userModel.avatar = avatar;
    }

    if (nickname != null) {
      _userModel.nickname = nickname;
    }

    if (sex != null) {
      _userModel.sex = sex;
    }

    if (mobile != null) {
      _userModel.mobile = mobile;
    }

    if (email != null) {
      _userModel.email = email;
    }

    if (followers != null) {
      _userModel.followers = followers;
    }

    if (favourites != null) {
      _userModel.favourites = favourites;
    }
    notifyListeners();
    return SharedPref.saveUsers(_userModel.toJson());
  }
}
