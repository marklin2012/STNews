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
        SharedPref.getUsers()
            .then((user) => _userModel = UserModel.fromJson(user));
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
      notifyListeners();
    }

    if (avatar != null) {
      _userModel.avatar = avatar;
      notifyListeners();
    }

    if (nickname != null) {
      _userModel.nickname = nickname;
      notifyListeners();
    }

    if (sex != null) {
      _userModel.sex = sex;
      notifyListeners();
    }

    if (mobile != null) {
      _userModel.mobile = mobile;
      notifyListeners();
    }

    if (email != null) {
      _userModel.email = email;
      notifyListeners();
    }

    if (followers != null) {
      _userModel.followers = followers;
      notifyListeners();
    }

    if (favourites != null) {
      _userModel.favourites = favourites;
      notifyListeners();
    }

    return SharedPref.saveUsers(_userModel.toJson());
  }
}
