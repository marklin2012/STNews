class ResultData {
  final bool success;
  final int code;
  final String message;
  final dynamic data;

  ResultData(
      {required this.code,
      required this.message,
      this.data,
      required this.success});
  ResultData.error(
    this.message, {
    this.success = false,
    this.data,
    this.code = 0,
  });
}
