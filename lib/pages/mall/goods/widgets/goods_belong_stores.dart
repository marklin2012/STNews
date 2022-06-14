import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

enum GoodsBelongStoresType {
  goStores, // 进店
  isFavourited // 是否关注
}

class GoodsBelongStores extends StatelessWidget {
  const GoodsBelongStores({
    Key? key,
    required this.title,
    this.icon,
    this.rate = 0,
    this.goStoresTap,
    this.type = GoodsBelongStoresType.goStores,
    this.isFavourited = false,
    this.favouritedTap,
    this.decoration,
    this.margin,
    this.padding,
  }) : super(key: key);

  final String title;

  final String? icon;

  final double rate;

  final Function? goStoresTap;

  final GoodsBelongStoresType type;

  final bool isFavourited;

  final Function(bool)? favouritedTap;

  final BoxDecoration? decoration;

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.all(16),
      decoration: decoration ?? BoxDecoration(color: ColorConfig.primaryColor),
      child: Row(
        children: [
          _buildLogo(),
          Expanded(child: _buildTitleAndRate()),
          _buildTailing(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    if (icon != null) {
      return CachedNetworkImage(imageUrl: icon!);
    }
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: ColorConfig.baseThrBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        'LOGO',
        style: TextStyle(
          color: ColorConfig.primaryColor,
          fontSize: FONTSIZE12,
          fontWeight: FONTWEIGHT400,
        ),
      ),
    );
  }

  Widget _buildTitleAndRate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: NewsTextStyle.style16BoldBlack,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  '体验',
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
              ),
              STRate(
                rate: rate,
                iconSize: 16.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTailing() {
    if (type == GoodsBelongStoresType.isFavourited) {
      return STButton(
        height: 30,
        text: isFavourited ? '已关注' : '关注',
        radius: 4,
        type: STButtonType.outline,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderColor:
            isFavourited ? ColorConfig.textThrColor : ColorConfig.baseFirBule,
        textStyle: isFavourited
            ? NewsTextStyle.style16NormalThrGrey
            : NewsTextStyle.style16NormalFirBlue,
        onTap: () {
          if (favouritedTap == null) return;
          favouritedTap!(!isFavourited);
        },
      );
    }
    return STButton(
      text: '进店',
      radius: 2.0,
      textStyle: NewsTextStyle.style14NormalWhite,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      onTap: () {
        if (goStoresTap == null) return;
        goStoresTap!();
      },
    );
  }
}
