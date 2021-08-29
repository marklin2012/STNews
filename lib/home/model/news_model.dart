class NewsModel {
  String id;
  String title;
  String author;
  String image;
  bool selected;

  NewsModel(
    this.id,
    this.title,
    this.author,
    this.image, {
    this.selected = false,
  });
}
