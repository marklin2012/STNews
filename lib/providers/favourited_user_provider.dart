import 'package:flutter/material.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';

class FavouritedUserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  Future getFavouritedUsers() async {
    ResultData result = await Api.getUserFavouriteList();
    if (result.success) {
      List _temp = result.data['favourites'];
      _users = _temp.map((e) => UserModel.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future changeFavouritedUserStatus(int index) async {
    UserModel _user = users[index];
    ResultData result =
        await Api.changeUserFavourite(followeduserid: _user.id, status: false);
    if (result.success) {
      _users.removeAt(index);
      notifyListeners();
    }
  }
}
