import 'package:stnews/models/moment_model.dart';
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
  String? createdAt;
  String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UserInfoModel {
  UserModel? user;
  int? followerCount;
  int? fansCount;
  List<PostModel>? post;
  List<MomentModel>? moments;

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
    if (json['post'] is List) {
      List _temps = json['post'] as List;
      post = _temps.map((e) => PostModel.fromJson(e)).toList();
    }
    if (json['moments'] is List) {
      List _temps = json['moments'] as List;
      moments = _temps.map((e) => MomentModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user?.toJson();
    data['followerCount'] = this.followerCount;
    data['fansCount'] = this.fansCount;
    data['post'] = this.post?.map((e) => e.toJson()).toList();
    data['moments'] = this.moments?.map((e) => e.toJson()).toList();
    return data;
  }
}
