import 'package:stnews/models/comment_model.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/models/user_model.dart';

class MomentCommentModel {
  String? id;
  bool? istop;
  bool? deleted;
  String? content;
  MomentModel? moment;
  CommentModel? comment;
  CommentModel? reference;
  UserModel? user;
  String? publisheddate;
  String? createdAt;
  String? updatedAt;
  List<MomentCommentModel>? references;
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
    this.references,
    this.isUserFavourite,
    this.favouriteCount,
  });

  MomentCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istop = json['is_top'];
    deleted = json['deleted'];
    content = json['content'];
    if (json['moment'] is Map) {
      moment = MomentModel.fromJson(json['moment']);
    }
    if (json['comment'] is Map) {
      comment = CommentModel.fromJson(json['comment']);
    }
    if (json['reference'] is Map) {
      reference = CommentModel.fromJson(json['reference']);
    }
    if (json['user'] is Map) {
      user = UserModel.fromJson(json['user']);
    }
    publisheddate = json['published_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['references'] is List) {
      final temp = json['references'] as List;
      references = temp.map((e) => MomentCommentModel.fromJson(e)).toList();
    }
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
    data['comment'] = this.comment?.toJson();
    data['reference'] = this.reference?.toJson();
    data['user'] = this.user?.toJson();
    data['published_date'] = this.publisheddate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['references'] = this.reference?.toJson();
    data['isUserFavourite'] = this.isUserFavourite;
    data['favouriteCount'] = this.favouriteCount;
    return data;
  }
}
