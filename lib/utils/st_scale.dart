import 'package:flutter/material.dart';

class NewsScale {
  static const designW = 375.0;

  static const designH = 812.0;

  static double screenW(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenH(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double safeTop(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double safeBottom(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double sw(double width, BuildContext context) =>
      width * NewsScale.screenW(context) / NewsScale.designW;

  static double sh(double height, BuildContext context) =>
      height * NewsScale.screenH(context) / NewsScale.designH;
}
