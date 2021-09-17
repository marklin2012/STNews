class NoticeModel {
  String? id;
  String? image;
  String? title;
  String? subtitle;
  late DateTime datetime;
  int? notices;

  NoticeModel({
    this.id,
    this.title,
    required this.datetime,
    this.image,
    this.subtitle,
    this.notices,
  });

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    subtitle = json['subTitle'];
    datetime = json['dateTime'] ?? DateTime.now();
    notices = json['notices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['subTitle'] = this.subtitle;
    data['dateTime'] = this.datetime;
    data['notices'] = this.notices;
    return data;
  }
}
