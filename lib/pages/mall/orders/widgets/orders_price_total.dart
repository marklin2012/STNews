import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class OrdersPriceTotal extends StatelessWidget {
  const OrdersPriceTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: [
          // 商品金额
          _buildGoodsPrice(),
          // 优惠
          _buildStoresDiscount(),
          // 运费
          _buildFreight(),
          // 合计
          _buildTotal(),
        ],
      ),
    );
  }

  Widget _buildGoodsPrice() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '商品金额',
            style: NewsTextStyle.style14NormalBlack,
          ),
          GoodsShowPrice(
            price: '289',
            smallFontSize: FONTSIZE14,
            fontSize: FONTSIZE16,
            fontColor: ColorConfig.textFirColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStoresDiscount() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '店铺优惠',
            style: NewsTextStyle.style14NormalBlack,
          ),
          Text(
            '暂无优惠',
            style: NewsTextStyle.style14NormalFourGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildFreight() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '运费',
            style: NewsTextStyle.style14NormalBlack,
          ),
          Text(
            '添加/更换地址后方可计算运费¥-',
            style: NewsTextStyle.style14NormalFourGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      padding: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ColorConfig.thrGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '总计：',
            style: NewsTextStyle.style14NormalBlack,
          ),
          GoodsShowPrice(
            price: '289',
            smallFontSize: FONTSIZE14,
            fontSize: FONTSIZE16,
            fontColor: ColorConfig.textFirColor,
          ),
        ],
      ),
    );
  }
}
