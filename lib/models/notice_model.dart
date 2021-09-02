class NoticeModel {
  String id;
  String? image;
  String title;
  String? subTitle;
  DateTime dateTime;
  int? notices;

  NoticeModel(
    this.id,
    this.title,
    this.dateTime, {
    this.image,
    this.subTitle,
    this.notices,
  });
}
