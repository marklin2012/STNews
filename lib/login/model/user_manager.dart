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

  String _token = '';

  UserManager._() {
    SharedPref.getToken().then((token) {
      if (token != null) {
        _token = token;
        SharedPref.getUsers()
            .then((user) => _userModel = UserModel.fromJson(user));
      }
    });
  }

  setTpkenAndUser(String? token, UserModel? userModel) {
    if (token != null) {
      _token = token;
    }
    if (userModel != null) {
      _userModel = userModel;
    }
    if (token != null || userModel != null) {
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
      user.username = username;
      notifyListeners();
    }

    if (avatar != null) {
      user.avatar = avatar;
      notifyListeners();
    }

    if (nickname != null) {
      user.nickname = nickname;
      notifyListeners();
    }

    if (sex != null) {
      user.sex = sex;
      notifyListeners();
    }

    if (mobile != null) {
      user.mobile = mobile;
      notifyListeners();
    }

    if (email != null) {
      user.email = email;
      notifyListeners();
    }

    if (followers != null) {
      user.followers = followers;
      notifyListeners();
    }

    if (favourites != null) {
      user.favourites = favourites;
      notifyListeners();
    }

    return SharedPref.saveUsers(user.toJson());
  }
}
