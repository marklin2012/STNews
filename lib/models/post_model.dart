import 'package:stnews/models/user_model.dart';

class PostModel {
  String? id;
  bool? istop;
  String? title;
  String? article;
  String? headimages;
  UserModel? author;
  String? publishdate;
  String? favourites;
  bool? deleted;

  bool? selected;

  PostModel({
    this.id,
    this.istop,
    this.title,
    this.article,
    this.headimages,
    this.author,
    this.publishdate,
    this.favourites,
    this.deleted,
    this.selected = false,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istop = json['is_top'];
    title = json['title'];
    article = json['article'];
    headimages = json['head_images'];
    author = UserModel.fromJson(json['author']);
    publishdate = json['publish_date'];
    deleted = json['deleted'];
    favourites = json['favourites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['is_top'] = this.istop;
    data['title'] = this.title;
    data['article'] = this.article;
    data['head_images'] = this.headimages;
    data['author'] = this.author?.toJson();
    data['publish_date'] = this.publishdate;
    data['deleted'] = this.deleted;
    data['favourites'] = this.favourites;
    return data;
  }
}
