import 'package:flutter/material.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';

class UserHomeProvider extends ChangeNotifier {
  String _userID = '';
  String get userID => _userID;
  set userID(String? userID) {
    if (userID != null) {
      _userID = userID;
      notifyListeners();
    }
  }

  UserInfoModel _infoModel = UserInfoModel();
  UserInfoModel get infoModel => _infoModel;
  set infoModel(UserInfoModel? model) {
    if (model != null) {
      _infoModel = model;
      notifyListeners();
    }
  }

  bool get isSelf {
    if (userID.isEmpty || userID.length < 2) return true;
    return (userID == UserProvider.shared.user.id);
  }

  bool _isFavouritedUser = false;
  bool get isFavouritedUser => _isFavouritedUser;
  set isFavouritedUser(bool? isFav) {
    if (isFav != null) {
      _isFavouritedUser = isFav;
      notifyListeners();
    }
  }

  /// 获取该用户的信息
  Future getUserInfoData() async {
    ResultData result = await Api.getUserInfo(userid: userID);
    if (result.success) {
      Map<String, dynamic> _userInfo = result.data;
      infoModel = UserInfoModel.fromJson(_userInfo);
    }
  }

  /// 查询是否关注了该用户
  Future getFavouritedUser() async {
    ResultData result = await Api.getUserFavouriteList();
    if (result.success) {
      List _temp = result.data['favourites'];
      List<UserModel> _favouriteLists =
          _temp.map((e) => UserModel.fromJson(e)).toList();
      _isFavouritedUser = false;
      for (var item in _favouriteLists) {
        if (item.id == userID) {
          isFavouritedUser = true;
          break;
        }
      }
    }
  }

  /// 关注或取消关注该用户
  Future<bool> changeFavouritedUserStatus() async {
    ResultData result = await Api.changeUserFavourite(
        followeduserid: userID, status: !_isFavouritedUser);
    if (result.success) {
      isFavouritedUser = !_isFavouritedUser;
    }
    return isFavouritedUser;
  }
}
