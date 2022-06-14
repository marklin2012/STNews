import 'package:flutter/material.dart';
import 'package:stnews/providers/color_theme_provider.dart';

const primaryColorKey = "primaryColor";
const backgroundColorKey = "backgroundColor";
const accentColorKey = "accentColor";
const baseFirBuleKey = "baseFirBule";
const baseSecBuleKey = "baseSecBule";
const baseThrBuleKey = "baseThrBule";
const baseFourBlueKey = "baseFourBlue";
const assistRedKey = "assistRed";
const assistYellowKey = "assistYellow";
const assistGreenKey = "assistGreen";
const firGreyKey = "firGrey";
const secGreyKey = "secGrey";
const thrGreyKey = "thrGrey";
const fourGreyKey = "fourGrey";
const textFirColorKey = "textFirColor";
const textSecColorKey = "textSecColor";
const textThrColorKey = "textThrColor";
const textFourColorKey = "textFourColor";
const shadeFirColorKey = "shadeFirColor";
const shadeSecColorKey = "shadeSecColor";
const shadeThrColorKey = "shadeThrColor";
const orangeColorKey = 'orangeColorKey';
const redColorKey = 'redColorKey';
const deepBlackColorKey = 'deepBlackColorKey';

Map<String, Color> lightColorMap = {
  primaryColorKey: Colors.white,
  backgroundColorKey: Color(0xFFFAFCFF),
  accentColorKey: Color(0xFF4585FF),
  baseFirBuleKey: Color(0xFF095BF9),
  baseSecBuleKey: Color(0xFF4585FF),
  baseThrBuleKey: Color(0xFFA6C4FF),
  baseFourBlueKey: Color(0xFFDCE8FF),
  assistRedKey: Color(0xFFFF4141),
  assistYellowKey: Color(0xFFFFA927),
  assistGreenKey: Color(0xFF49C564),
  firGreyKey: Color(0xFF787878),
  secGreyKey: Color(0xFFC4C5C7),
  thrGreyKey: Color(0xFFDFE2E7),
  fourGreyKey: Color(0xFFEFF3F9),
  textFirColorKey: Colors.black,
  textSecColorKey: Color(0xFF555555),
  textThrColorKey: Color(0xFF888888),
  textFourColorKey: Color(0xFFBBBBBB),
  shadeFirColorKey: Color.fromRGBO(0, 0, 0, 0.8),
  shadeSecColorKey: Color.fromRGBO(0, 0, 0, 0.6),
  shadeThrColorKey: Color.fromRGBO(0, 0, 0, 0.5),
  orangeColorKey: Color(0xFFFFA927),
  redColorKey: Color(0xFFFF4141),
  deepBlackColorKey: Color(0xFF333333),
};

/// 尚未完成深色模式下的页面配置
Map<String, Color> darkColorMap = {
  primaryColorKey: Colors.black,
  backgroundColorKey: Color(0xFF111111),
  accentColorKey: Color(0xFF4585FF),
  baseFirBuleKey: Color(0xFF095BF9),
  baseSecBuleKey: Color(0xFF4585FF),
  baseThrBuleKey: Color(0xFFA6C4FF),
  baseFourBlueKey: Color(0xFFDCE8FF),
  assistRedKey: Color(0xFFFF4141),
  assistYellowKey: Color(0xFFFFA927),
  assistGreenKey: Color(0xFF49C564),
  firGreyKey: Color(0xFF787878),
  secGreyKey: Color(0xFFC4C5C7),
  thrGreyKey: Color(0xFFDFE2E7),
  fourGreyKey: Color(0xFFEFF3F9),
  textFirColorKey: Colors.white,
  textSecColorKey: Color(0xFFEEEEEE),
  textThrColorKey: Color(0xFFCCCCCC),
  textFourColorKey: Color(0xFFAAAAAA),
  shadeFirColorKey: Color.fromRGBO(0, 0, 0, 0.8),
  shadeSecColorKey: Color.fromRGBO(0, 0, 0, 0.6),
  shadeThrColorKey: Color.fromRGBO(0, 0, 0, 0.5),
  orangeColorKey: Color(0xFFFFA927),
  redColorKey: Color(0xFFFF4141),
  deepBlackColorKey: Color(0xFF333333),
};

class ColorConfig {
  /// 获取颜色
  static Color colorFromName(String colorName) {
    Color? color = lightColorMap[colorName];
    if (ColorThemeProvider.shared.themeMode == ThemeMode.dark) {
      color = darkColorMap[colorName];
    }
    return color ?? Colors.white;
  }

  static get primaryColor => ColorConfig.colorFromName(primaryColorKey);
  static get backgroundColor => ColorConfig.colorFromName(backgroundColorKey);
  static get accentColor => ColorConfig.colorFromName(accentColorKey);
  static get baseFirBule => ColorConfig.colorFromName(baseFirBuleKey);
  static get baseSecBule => ColorConfig.colorFromName(baseSecBuleKey);
  static get baseThrBlue => ColorConfig.colorFromName(baseThrBuleKey);
  static get baseFourBlue => ColorConfig.colorFromName(baseFourBlueKey);
  static get assistRed => ColorConfig.colorFromName(assistRedKey);
  static get assistYellow => ColorConfig.colorFromName(assistYellowKey);
  static get assistGreen => ColorConfig.colorFromName(assistGreenKey);
  static get firGrey => ColorConfig.colorFromName(firGreyKey);
  static get secGrey => ColorConfig.colorFromName(secGreyKey);
  static get thrGrey => ColorConfig.colorFromName(thrGreyKey);
  static get fourGrey => ColorConfig.colorFromName(fourGreyKey);
  static get textFirColor => ColorConfig.colorFromName(textFirColorKey);
  static get textSecColor => ColorConfig.colorFromName(textSecColorKey);
  static get textThrColor => ColorConfig.colorFromName(textThrColorKey);
  static get textFourColor => ColorConfig.colorFromName(textFourColorKey);
  static get shadeFirColor => ColorConfig.colorFromName(shadeFirColorKey);
  static get shadeSecColor => ColorConfig.colorFromName(shadeSecColorKey);
  static get shadeThrColor => ColorConfig.colorFromName(shadeThrColorKey);
  static get orangeColor => ColorConfig.colorFromName(orangeColorKey);
  static get redColor => ColorConfig.colorFromName(redColorKey);
  static get deepBlackColor => ColorConfig.colorFromName(deepBlackColorKey);
}
