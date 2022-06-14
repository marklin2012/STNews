import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class GoodsDetailContent extends StatelessWidget {
  const GoodsDetailContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: [
          _buildPrice(),
          Text(
            '爱只为你音乐盒木质八音盒旋转木马爱只为你音乐盒木质八音盒旋转木马',
            style: NewsTextStyle.style16BoldBlack,
          ),
          _buildSales(),
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GoodsShowPrice(price: '289'),
              GoodsShowOriginPrice(
                padding: EdgeInsets.only(left: 8),
                originPrice: '328',
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 20,
                margin: EdgeInsets.only(left: 4),
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: ColorConfig.assistRed,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '满500减50',
                  style: NewsTextStyle.style12NormalWhite,
                ),
              ),
              Container(
                height: 20,
                margin: EdgeInsets.only(left: 4),
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: ColorConfig.assistYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '满500减50',
                  style: NewsTextStyle.style12NormalWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSales() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              '月销269',
              style: NewsTextStyle.style12NormalThrGrey,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: ColorConfig.thrGrey),
              ),
            ),
            child: Text(
              '包邮',
              style: NewsTextStyle.style12NormalThrGrey,
            ),
          ),
        ],
      ),
    );
  }
}
