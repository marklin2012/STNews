import 'package:flutter/material.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/utils/shared_pref.dart';

class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel.fromJson({});

  UserModel get user => _userModel;

  static late UserProvider _shared;

  static UserProvider get shared => UserProvider._shardProvider();

  static UserProvider _shardProvider() {
    _shared = UserProvider._();
    return _shared;
  }

  UserProvider._() {
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