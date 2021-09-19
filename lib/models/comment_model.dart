import 'package:stnews/models/post_model.dart';
import 'package:stnews/models/user_model.dart';

class CommentModel {
  String? id;
  bool? istop;
  PostModel? post;
  String? content;
  UserModel? user;
  String? publisheddate;
  bool? isUserFavourite;
  int? favouriteCount;

  CommentModel({
    this.id,
    this.istop,
    this.post,
    this.content,
    this.user,
    this.publisheddate,
    this.isUserFavourite,
    this.favouriteCount,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istop = json['is_top'];
    if (json['post'] is Map<String, dynamic>) {
      post = PostModel.fromJson(json['post']);
    } else if (json['post'] is String) {
      post = PostModel(id: json['post']);
    }
    content = json['content'];
    if (json['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['user']);
    } else if (json['user'] is String) {
      user = UserModel(id: json['user']);
    }
    publisheddate = json['published_date'];
    isUserFavourite = json['isUserFavourite'];
    favouriteCount = json['favouriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['is_top'] = this.istop;
    data['post'] = this.post?.toJson();
    data['content'] = this.content;
    data['user'] = this.user?.toJson();
    data['published_date'] = this.publisheddate;
    data['isUserFavourite'] = this.isUserFavourite;
    data['favouriteCount'] = this.favouriteCount;
    return data;
  }
}
