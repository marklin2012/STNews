import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_goods_image.dart';
import 'package:stnews/utils/news_text_style.dart';

class ShoppingGoodsWidget extends StatelessWidget {
  const ShoppingGoodsWidget({
    Key? key,
    this.margin,
    this.padding,
    this.decoration,
    this.showPriceAndNumbers = true,
  }) : super(key: key);

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  final BoxDecoration? decoration;

  final bool showPriceAndNumbers;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShoppingGoodsImage(
            margin: EdgeInsets.only(right: 12),
            outOfStock: true,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Container(
                  height: 44,
                  child: Text(
                    '爱只为你音乐盒木质八音盒旋盒音乐盒木质八音盒旋盒爱只为你音乐盒木质八音盒旋盒音乐盒木质八音盒旋盒',
                    style: NewsTextStyle.style14NormalBlack,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 已选属性
                _getSelectedAttributes(),
                // 是否显示价格和数量
                if (showPriceAndNumbers) _buildPriceAndNumbers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndNumbers() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      height: 26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 价格
          GoodsShowPrice(
            price: '289',
            smallFontSize: FONTSIZE14,
            fontSize: FONTSIZE18,
          ),
          STStepper(
            value: 1,
            minValue: 1,
          ),
        ],
      ),
    );
  }

  // 可多个属性
  Widget _getSelectedAttributes() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 5.0,
        children: ['盒装', '柠檬味'].map((e) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 20,
            decoration: BoxDecoration(
              color: ColorConfig.fourGrey,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              e,
              style: NewsTextStyle.style12NormalSecGrey,
            ),
          );
        }).toList(),
      ),
    );
  }
}
