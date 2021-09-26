import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Newstoast {
  static showToast({
    required String msg,
    Toast timeLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor = Colors.black,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: timeLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
    );
  }
}
