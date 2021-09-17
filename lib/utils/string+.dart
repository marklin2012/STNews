class STString {
  static String securityMobile(String mobile) {
    if (mobile.length <= 7) {
      return mobile;
    }

    /// 前3后4 其余用*代替
    int _length = mobile.length;
    final _lead = mobile.substring(0, 3);
    final _tail = mobile.substring(_length - 4, _length);
    var _center = '';
    for (int i = 0; i < _length - 7; i++) {
      _center += '*';
    }
    return _lead + _center + _tail;
  }

  static String removeSpace(String string) {
    return string.replaceAll(' ', '');
  }

  static String removeSpaceAndSecurity(String mobile) {
    final _temp = STString.removeSpace(mobile);
    return STString.securityMobile(_temp);
  }

  static String getDateString(DateTime time) {
    if (time.isAfter(DateTime.now().add(Duration(minutes: -30)))) {
      return '刚刚';
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -1)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different == 0) {
        return '今天';
      } else {
        return '昨天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -2)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different <= 1) {
        return '昨天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -365)))) {
      final month = time.month;
      final day = time.day;
      return '$month-$day';
    }
    final year = time.year;
    final month = time.month;
    final day = time.day;
    return '$year-$month-$day';
  }
}
