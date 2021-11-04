import 'package:stnews/models/user_model.dart';

class MomentModel {
  String? id;
  List<String>? images;
  List<String>? visibles;
  UserModel? user;
  String? title;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? favouriteCount;

  MomentModel({
    this.id,
    this.images,
    this.visibles,
    this.user,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.favouriteCount,
  });

  MomentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['images'] is List) {
      final _temp = json['images'] as List;
      images = _temp.map((e) => e.toString()).toList();
    }
    if (json['visibles'] is List) {
      final _temp = json['visibles'] as List;
      visibles = _temp.map((e) => e.toString()).toList();
    }
    if (json['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['user']);
    } else if (json['user'] is String) {
      user = UserModel(id: json['user']);
    }
    title = json['title'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    favouriteCount = json['favouriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['images'] = this.images;
    data['visibles'] = this.visibles;
    data['user'] = this.user?.toJson();
    data['title'] = this.title;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['favouriteCount'] = this.favouriteCount;
    return data;
  }
}
