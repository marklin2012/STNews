import 'dart:ffi';

import 'package:stnews/models/user_model.dart';

/// NoticeModel中type
/// sys 系统消息, fav 收藏事件, up 点赞事件
class NotifyType {
  static String sysType = 'sys';
  static String favType = 'fav';
  static String upType = 'up';
}

class NoticeModel {
  String? id;
  bool? isRead;
  String? type;
  String? description;
  UserModel? recipientID;
  AnnounceModel? announceID;
  String? createdAt;
  String? updatedAt;

  NoticeModel({
    this.id,
    this.isRead,
    this.type,
    this.description,
    this.recipientID,
    this.announceID,
    this.createdAt,
    this.updatedAt,
  });

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isRead = json['isRead'];
    type = json['type'];
    description = json['description'];
    recipientID = UserModel.fromJson(json['recipientID']);
    announceID = AnnounceModel.fromJson(json['announceID']);
    createdAt = json['createdAt'] ?? DateTime.now();
    updatedAt = json['updatedAt'] ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['isRead'] = this.isRead;
    data['type'] = this.type;
    data['description'] = this.description;
    data['recipientID'] = this.recipientID?.toJson();
    data['announceID'] = this.announceID?.toJson();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class AnnounceModel {
  String? id;
  String? subscript;
  String? content;
  UserModel? sender;
  String? title;
  String? createdAt;
  String? updatedAt;

  AnnounceModel({
    this.id,
    this.subscript,
    this.content,
    this.sender,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  AnnounceModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    subscript = json['subscript'];
    content = json['content'];
    sender = UserModel.fromJson(json['sender']);
    title = json['title'];
    createdAt = json['createdAt'] ?? DateTime.now();
    updatedAt = json['updatedAt'] ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['subscript'] = this.subscript;
    data['content'] = this.content;
    data['sender'] = this.sender?.toJson();
    data['title'] = this.title;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
