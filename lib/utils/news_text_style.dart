import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';

const FONTWEIGHT400 = FontWeight.w400;
const FONTWEIGHT500 = FontWeight.w500;

const FONTSIZE12 = 12.0;
const FONTSIZE14 = 14.0;
const FONTSIZE16 = 16.0;
const FONTSIZE17 = 17.0;
const FONTSIZE18 = 18.0;
const FONTSIZE22 = 22.0;
const FONTSIZE28 = 28.0;

class NewsTextStyle {
  static get style12NormalThrGrey => TextStyle(
        color: ColorConfig.textThrColor,
        fontSize: FONTSIZE12,
        fontWeight: FONTWEIGHT400,
      );

  static get style12NormalBlack => TextStyle(
        color: ColorConfig.textFirColor,
        fontSize: FONTSIZE12,
        fontWeight: FONTWEIGHT400,
      );

  static get style14NormalSecGrey => TextStyle(
        color: ColorConfig.textSecColor,
        fontSize: FONTSIZE14,
        fontWeight: FONTWEIGHT400,
      );

  static get style14NormalThrGrey => TextStyle(
        color: ColorConfig.textThrColor,
        fontSize: FONTSIZE14,
        fontWeight: FONTWEIGHT400,
      );

  static get style14NormalWhite => TextStyle(
        color: ColorConfig.primaryColor,
        fontSize: FONTSIZE14,
        fontWeight: FONTWEIGHT400,
        decoration: TextDecoration.none,
      );

  static get style14NormalBlack => TextStyle(
        color: ColorConfig.textFirColor,
        fontSize: FONTSIZE14,
        fontWeight: FONTWEIGHT400,
      );

  static get style14NormalFourGrey => TextStyle(
        color: ColorConfig.textFourColor,
        fontSize: FONTSIZE14,
        fontWeight: FONTWEIGHT400,
      );

  static get style16BoldBlack => TextStyle(
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT500,
        color: ColorConfig.textFirColor,
      );

  static get style16NormalWhite => TextStyle(
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.primaryColor,
      );

  static get style16NormalBlack => TextStyle(
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.textFirColor,
      );

  static get style16NormalFirBlue => TextStyle(
        color: ColorConfig.baseFirBule,
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
      );

  static get style16BoldFirBlue => TextStyle(
        color: ColorConfig.baseFirBule,
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT500,
      );

  static get style16NormalSecBlue => TextStyle(
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.baseSecBule,
      );

  static get style16NormalSecGrey => TextStyle(
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.textSecColor,
      );

  static get style16NormalFourGrey => TextStyle(
        color: ColorConfig.textFourColor,
        fontSize: FONTSIZE16,
        fontWeight: FONTWEIGHT400,
      );

  static get style17NormalBlack => TextStyle(
        fontSize: FONTSIZE17,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.textFirColor,
      );

  static get style17NormalFirBlue => TextStyle(
        fontSize: FONTSIZE17,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.baseFirBule,
      );

  static get style17NormalFourGrey => TextStyle(
        fontSize: FONTSIZE17,
        fontWeight: FONTWEIGHT400,
        color: ColorConfig.textFourColor,
      );

  static get style17BoldBlack => TextStyle(
        fontSize: FONTSIZE17,
        fontWeight: FONTWEIGHT500,
        color: ColorConfig.textFirColor,
      );

  static get style18BoldSecBlue => TextStyle(
        fontSize: FONTSIZE18,
        fontWeight: FONTWEIGHT500,
        color: ColorConfig.baseSecBule,
      );

  static get style18BoldWhite => TextStyle(
        color: ColorConfig.primaryColor,
        fontSize: FONTSIZE18,
        fontWeight: FONTWEIGHT500,
      );

  static get style18BoldBlack => TextStyle(
        color: ColorConfig.textFirColor,
        fontSize: FONTSIZE18,
        fontWeight: FontWeight.bold,
      );

  static get style22BoldBlack => TextStyle(
        fontSize: FONTSIZE22,
        fontWeight: FONTWEIGHT500,
        color: ColorConfig.textFirColor,
      );

  static get style28BoldBlack => TextStyle(
        fontSize: FONTSIZE28,
        fontWeight: FontWeight.bold,
        color: ColorConfig.textFirColor,
      );
}
