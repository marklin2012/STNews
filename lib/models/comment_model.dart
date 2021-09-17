import 'package:stnews/models/user_model.dart';

class CommentModel {
  String? postid;
  String? content;
  UserModel? user;
  String? favourites;
  DateTime? pubishtime;
  bool? deleted;

  CommentModel({
    this.postid,
    this.content,
    this.user,
    this.favourites,
    this.pubishtime,
    this.deleted = false,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
    content = json['content'];
    user = UserModel.fromJson(json['user']);
    favourites = json['favourites'];
    pubishtime = json['pubishtime'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postid'] = this.postid;
    data['content'] = this.content;
    data['user'] = this.user?.toJson();
    data['favourites'] = this.favourites;
    data['pubishtime'] = this.pubishtime;
    data['deleted'] = this.deleted;
    return data;
  }
}
