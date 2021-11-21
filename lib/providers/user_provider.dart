import 'package:flutter/material.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/shared_pref.dart';

class UserProvider extends ChangeNotifier {
  UserInfoModel _infoModel = UserInfoModel();

  UserInfoModel get info => _infoModel;

  UserModel get user => _infoModel.user ?? UserModel();

  static UserProvider? _shared;

  static UserProvider get shared => UserProvider._shardProvider();

  String? _token;

  String get token => _token ?? '';

  bool get isLogin {
    return _token != null && _token!.length != 0;
  }

  static UserProvider _shardProvider() {
    _shared ??= UserProvider._();
    return _shared!;
  }

  UserProvider._() {
    SharedPref.getToken().then((localToken) {
      if (localToken != null && localToken.length != 0) {
        setToken(localToken);
        SharedPref.getUsers().then((localUser) {
          UserModel _localUserModel = UserModel.fromJson(localUser);
          getUserInfo(userID: _localUserModel.id);
        });
      }
    });
  }

  void setToken(String? token, {isReload = false}) {
    if (token != null) {
      _token = token;
      Api.setAuthHeader(token);
      SharedPref.saveToken(token);
      if (isReload) notifyListeners();
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
      _infoModel.user?.username = username;
    }

    if (avatar != null) {
      _infoModel.user?.avatar = avatar;
    }

    if (nickname != null) {
      _infoModel.user?.nickname = nickname;
    }

    if (sex != null) {
      _infoModel.user?.sex = sex;
    }

    if (mobile != null) {
      _infoModel.user?.mobile = mobile;
    }

    if (email != null) {
      _infoModel.user?.email = email;
    }
    notifyListeners();
    return SharedPref.saveUsers(_infoModel.user?.toJson());
  }

  /// 获取用户资料
  void getUserInfo({String? userID}) async {
    ResultData result = await Api.getUserInfo(userid: userID ?? user.id);
    if (result.success) {
      Map<String, dynamic> _userInfo = result.data;
      _infoModel = UserInfoModel.fromJson(_userInfo);
      SharedPref.saveUsers(_infoModel.user?.toJson());
      notifyListeners();
    }
  }
}
