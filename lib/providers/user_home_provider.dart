import 'package:flutter/material.dart';
import 'package:stnews/models/moment_model.dart';
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

  bool get hasMoments => _infoModel.moments?.isNotEmpty ?? false;

  /// 获取该用户的信息
  Future getUserInfoData() async {
    ResultData result = await Api.getUserInfo(userid: userID);
    if (result.success) {
      Map<String, dynamic> _userInfo = result.data;
      infoModel = UserInfoModel.fromJson(_userInfo);
      notifyListeners();
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
  Future<bool> changeFavouritedUserStatus(bool isFaved) async {
    bool _isFaved = isFaved;
    ResultData result = await Api.changeUserFavourite(
        followeduserid: userID, status: !_isFaved);
    if (result.success) {
      isFavouritedUser = !_isFaved;
    }
    return isFavouritedUser;
  }

  /// 收藏或取消收藏圈子
  Future<bool> favouritedMoment({required String momentID, bool? isFav}) async {
    bool _isFav = isFav ?? false;
    ResultData result =
        await Api.changeMomentFavourite(moment: momentID, status: !_isFav);
    if (result.success) {
      _isFav = !_isFav;
      for (int i = 0; i < (_infoModel.moments?.length ?? 0); i++) {
        MomentModel moment = _infoModel.moments?[i] ?? MomentModel();
        if (moment.id == momentID) {
          moment.isFavourite = _isFav;
          break;
        }
      }
      notifyListeners();
    }
    return Future.value(_isFav);
  }

  /// 点赞或取消点赞圈子
  Future<bool> thumbupMoment(
      {required String momentID, bool? isThumbup}) async {
    bool _isThumbup = isThumbup ?? false;
    ResultData result =
        await Api.changeMomentThumbup(moment: momentID, status: !_isThumbup);
    if (result.success) {
      _isThumbup = !_isThumbup;
      for (int i = 0; i < (_infoModel.moments?.length ?? 0); i++) {
        MomentModel moment = _infoModel.moments?[i] ?? MomentModel();
        if (moment.id == momentID) {
          moment.isThumbUp = _isThumbup;
          if (_isThumbup) {
            moment.thumbUpCount = (moment.thumbUpCount ?? 0) + 1;
          } else {
            moment.thumbUpCount = (moment.thumbUpCount ?? 1) - 1;
          }
          break;
        }
      }
      notifyListeners();
    }
    return Future.value(_isThumbup);
  }
}
