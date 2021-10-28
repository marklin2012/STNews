import 'package:stnews/models/user_model.dart';

class CircleModel {
  String? id;
  String? coverImage;
  String? title;
  UserModel? user;
  bool? isUserFavourite;
  int? favouriteCount;

  CircleModel({
    this.id,
    this.coverImage,
    this.title,
    this.user,
    this.isUserFavourite,
    this.favouriteCount,
  });

  CircleModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    coverImage = json['coverImage'];
    title = json['title'];
    user = UserModel.fromJson(json['user']);
    isUserFavourite = json['isUserFavourite'];
    favouriteCount = json['favouriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['coverImage'] = this.coverImage;
    data['title'] = this.title;
    data['user'] = this.user?.toJson();
    data['isUserFavourite'] = this.isUserFavourite;
    data['favouriteCount'] = this.favouriteCount;
    return data;
  }
}
