import 'package:stnews/models/user_model.dart';

class PostModel {
  String? id;
  bool? istop;
  String? title;
  String? article;
  List<String>? headimages;
  String? coverImage;
  UserModel? author;
  String? publisheddate;
  bool? deleted;

  bool? selected;

  PostModel({
    this.id,
    this.istop,
    this.title,
    this.article,
    this.headimages,
    this.coverImage,
    this.author,
    this.publisheddate,
    this.deleted,
    this.selected = false,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istop = json['is_top'];
    title = json['title'];
    article = json['article'];
    // headimages = json['head_images'] as List<String>;
    coverImage = json['cover_image'];
    author = UserModel.fromJson(json['author']);
    publisheddate = json['published_date'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['is_top'] = this.istop;
    data['title'] = this.title;
    data['article'] = this.article;
    data['head_images'] = this.headimages;
    data['author'] = this.author?.toJson();
    data['published_date'] = this.publisheddate;
    data['deleted'] = this.deleted;
    return data;
  }
}
