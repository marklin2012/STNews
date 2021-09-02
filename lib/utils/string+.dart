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
}
