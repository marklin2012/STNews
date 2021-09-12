class PostModel {
  String? id;
  bool? isTop;
  String? title;
  String? article;
  String? headImages;
  String? author;
  String? publishDate;
  String? favourites;
  bool? deleted;

  bool? selected;

  PostModel({
    this.id,
    this.isTop,
    this.title,
    this.article,
    this.headImages,
    this.author,
    this.publishDate,
    this.favourites,
    this.deleted,
    this.selected = false,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isTop = json['is_top'];
    title = json['title'];
    article = json['article'];
    headImages = json['head_images'];
    author = json['author'];
    publishDate = json['publish_date'];
    deleted = json['deleted'];
    favourites = json['favourites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['is_top'] = this.isTop;
    data['title'] = this.title;
    data['article'] = this.article;
    data['head_images'] = this.headImages;
    data['author'] = this.author;
    data['publish_date'] = this.publishDate;
    data['deleted'] = this.deleted;
    data['favourites'] = this.favourites;
    return data;
  }
}
