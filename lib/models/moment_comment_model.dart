import 'package:stnews/models/moment_model.dart';
import 'package:stnews/models/user_model.dart';

class MomentCommentModel {
  String? id;
  bool? istop;
  bool? deleted;
  String? content;
  MomentModel? moment;
  String? comment;
  String? reference;
  UserModel? user;
  String? publisheddate;
  String? createdAt;
  String? updatedAt;
  bool? isUserFavourite;
  int? favouriteCount;

  MomentCommentModel({
    this.id,
    this.istop,
    this.deleted,
    this.content,
    this.moment,
    this.comment,
    this.reference,
    this.user,
    this.publisheddate,
    this.createdAt,
    this.updatedAt,
  });

  MomentCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istop = json['is_top'];
    deleted = json['deleted'];
    content = json['content'];
    if (json['moment'] is Map) {
      moment = MomentModel.fromJson(json['moment']);
    }
    comment = json['comment'];
    reference = json['reference'];
    if (json['user'] is Map) {
      user = UserModel.fromJson(json['user']);
    }
    publisheddate = json['published_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isUserFavourite = json['isUserFavourite'];
    favouriteCount = json['favouriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['is_top'] = this.istop;
    data['deleted'] = this.deleted;
    data['moment'] = this.moment?.toJson();
    data['content'] = this.content;
    data['comment'] = this.comment;
    data['reference'] = this.reference;
    data['user'] = this.user?.toJson();
    data['published_date'] = this.publisheddate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isUserFavourite'] = this.isUserFavourite;
    data['favouriteCount'] = this.favouriteCount;
    return data;
  }
}
