import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_goods_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class OrdersGoods extends StatelessWidget {
  const OrdersGoods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Baby Star旗舰店',
              style: NewsTextStyle.style14NormalBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: ShoppingGoodsWidget(),
          ),
        ],
      ),
    );
  }
}
