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

  String? moment;
  String? comment;
  String? reference;
  String? createdAt;
  String? updatedAt;

  CommentModel({
    this.id,
    this.istop,
    this.post,
    this.content,
    this.user,
    this.publisheddate,
    this.isUserFavourite,
    this.favouriteCount,
    this.moment,
    this.comment,
    this.reference,
    this.createdAt,
    this.updatedAt,
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

    moment = json['moment'];
    comment = json['comment'];
    reference = json['reference'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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

    data['moment'] = this.moment;
    data['comment'] = this.comment;
    data['reference'] = this.reference;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
