import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:stnews/service/api.dart';

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
    if (time.isAfter(DateTime.now().add(Duration(days: -1)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different == 0) {
        String hour = time.hour.toString();
        String minute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
        return hour + ':' + minute;
      } else {
        return '昨天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -2)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different <= 1) {
        return '昨天';
      } else {
        return '前天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -3)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different <= 2) {
        return '前天';
      } else {
        return '大前天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -4)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different <= 3) {
        return '大前天';
      }
      final month = time.month;
      final day = time.day;
      return '$month-$day';
    }

    final month = time.month;
    final day = time.day;
    return '$month-$day';
  }

  // string转dateTime
  static DateTime dateTimeFromString(
      {required String dateStr, String format = "yyyy-MM-dd HH:mm:ss"}) {
    DateFormat _format = DateFormat(format);
    String _dateStr = dateStr.replaceAll('T', ' ');
    DateTime _temp = _format.parse(_dateStr);
    return _temp;
  }

  // 格式化时间
  static String dateTimeStrFromString({String? dateStr}) {
    DateTime _date = STString.dateTimeFromString(dateStr: dateStr ?? '');
    return STString.getDateString(_date);
  }

  // 计算文本是否超过指定的行数
  static bool textExceedMaxLined(
      {String? text,
      TextStyle? textStyle,
      int maxLines = 5,
      double? maxWidth}) {
    if (text != null && textStyle != null && maxWidth != null) {
      TextSpan textSpan = TextSpan(text: text, style: textStyle);
      TextPainter textPainter = TextPainter(
          text: textSpan,
          maxLines: maxLines,
          textDirection: ui.TextDirection.ltr);
      textPainter.layout(maxWidth: maxWidth);
      if (textPainter.didExceedMaxLines) {
        return true;
      }
    }
    return false;
  }

  static bool isPrefixHttp(String? url) {
    if (url == null) return false;
    if (url.startsWith('http')) {
      return true;
    }
    return false;
  }

  static String? addPrefixHttp(String? image) {
    if (image == null) return null;
    if (STString.isPrefixHttp(image)) {
      return image;
    } else {
      return BaseUrl + image;
    }
  }

  static String imageUrl({String? url, String? defaultAssets}) {
    if (url == null || url.length == 0) {
      return defaultAssets ?? '';
    }
    final _temp = STString.addPrefixHttp(url);
    return _temp ?? '';
  }

  static String limitStringLength(String? string, {int length = 8}) {
    if (string == null) return '';
    if (string.length <= length) return string;
    final temp = string.substring(0, 8);
    return '$temp...';
  }
}
