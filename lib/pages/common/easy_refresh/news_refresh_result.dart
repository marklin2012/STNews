class ResultRefreshData {
  final bool success;
  final bool hasMore;

  ResultRefreshData({
    required this.success,
    required this.hasMore,
  });

  ResultRefreshData.error({
    this.success = false,
    this.hasMore = false,
  });

  ResultRefreshData.noMore({
    this.success = true,
    this.hasMore = false,
  });

  ResultRefreshData.normal({
    this.success = true,
    this.hasMore = true,
  });
}
