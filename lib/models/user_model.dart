import 'package:stnews/models/post_model.dart';

class UserModel {
  String? id;
  String? username;
  String? password;
  String? avatar;
  String? nickname;
  int? sex;
  String? mobile;
  String? email;
  bool? deleted;
  int? followers;
  int? favourites;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.avatar,
    this.nickname,
    this.sex,
    this.mobile,
    this.email,
    this.deleted,
    this.followers,
    this.favourites,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    password = json['password'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    sex = json['sex'];
    mobile = json['mobile'];
    email = json['email'];
    deleted = json['deleted'];
    followers = json['followers'];
    favourites = json['favourites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['nickname'] = this.nickname;
    data['sex'] = this.sex;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['deleted'] = this.deleted;
    data['followers'] = this.followers;
    data['favourites'] = this.favourites;
    return data;
  }
}

class UserInfoModel {
  UserModel? user;
  int? followerCount;
  int? fansCount;
  List<PostModel>? post;

  UserInfoModel({
    this.user,
    this.followerCount,
    this.fansCount,
    this.post,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    user = UserModel.fromJson(json['user']);
    followerCount = json['followerCount'];
    fansCount = json['fansCount'];
    List _temps = json['post'] as List;
    post = _temps.map((e) => PostModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user?.toJson();
    data['followerCount'] = this.followerCount;
    data['fansCount'] = this.fansCount;
    data['post'] = this.post?.map((e) => e.toJson()).toList();
    return data;
  }
}
