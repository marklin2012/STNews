import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

class GoodsShowPrice extends StatelessWidget {
  const GoodsShowPrice({
    Key? key,
    required this.price,
    this.smallFontSize = FONTSIZE16,
    this.fontSize = FONTSIZE28,
    this.fontColor,
    this.fontWeight = FONTWEIGHT500,
    this.margin,
    this.padding,
  }) : super(key: key);

  final String price;

  final double smallFontSize;

  final double fontSize;

  final Color? fontColor;

  final FontWeight fontWeight;

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: fontColor ?? ColorConfig.assistRed),
          children: [
            TextSpan(
              text: '￥',
              style: TextStyle(
                fontSize: smallFontSize,
                fontWeight: FONTWEIGHT400,
              ),
            ),
            TextSpan(
              text: price,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoodsShowOriginPrice extends StatelessWidget {
  const GoodsShowOriginPrice({
    Key? key,
    this.margin,
    this.padding,
    required this.originPrice,
  }) : super(key: key);

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  final String originPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: RichText(
        text: TextSpan(
          style: NewsTextStyle.style12NormalThrGrey,
          children: [
            TextSpan(
              text: '价格 ',
            ),
            TextSpan(
              text: '￥$originPrice',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
