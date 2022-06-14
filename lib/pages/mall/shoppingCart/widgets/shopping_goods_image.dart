import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';

class ShoppingGoodsImage extends StatelessWidget {
  const ShoppingGoodsImage({
    Key? key,
    this.url,
    this.outOfStock = false,
    this.size = 100.0,
    this.margin,
    this.padding,
    this.decoration,
  }) : super(key: key);

  final String? url;

  final bool outOfStock; // 是否缺货

  final double size;

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            color: ColorConfig.baseFourBlue,
            borderRadius: BorderRadius.circular(4),
          ),
      height: size,
      width: size,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        _buildReal(),
        if (outOfStock)
          Positioned(
            left: size * 0.1,
            right: size * 0.1,
            top: size * 0.1,
            bottom: size * 0.1,
            child: _buildOutOfStock(),
          ),
      ],
    );
  }

  Widget _buildReal() {
    return NewsImage.networkImage(
      path: url,
      defaultChild: NewsImage.defaultCircle(height: 44),
    );
  }

  Widget _buildOutOfStock() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.shadeThrColor,
        borderRadius: BorderRadius.circular((size * 0.8 / 2)),
      ),
      child: Center(
        child: Text(
          '无货',
          style: NewsTextStyle.style16NormalWhite,
        ),
      ),
    );
  }
}
