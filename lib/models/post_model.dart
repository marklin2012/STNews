class PostModel {
  String? id;
  String? title;
  String? author;
  String? image;
  bool? selected;

  PostModel({
    this.id,
    this.title,
    this.author,
    this.image,
    this.selected = false,
  });
}
