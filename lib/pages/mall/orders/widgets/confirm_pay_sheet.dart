import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/utils/news_text_style.dart';

class ConfirmPaySheet extends StatelessWidget {
  const ConfirmPaySheet({
    Key? key,
    this.closeTap,
    this.confirmTap,
  }) : super(key: key);

  final VoidCallback? closeTap;

  final VoidCallback? confirmTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 12),
            child: STButton.icon(
              icon: Icon(
                STIcons.commonly_close_outline,
                color: ColorConfig.firGrey,
              ),
              backgroundColor: Colors.transparent,
              onTap: closeTap,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: GoodsShowPrice(
              price: '289',
              smallFontSize: 20,
              fontSize: 34,
              fontColor: ColorConfig.textFirColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: ColorConfig.thrGrey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '支付宝账号',
                  style: NewsTextStyle.style14NormalThrGrey,
                ),
                Text(
                  '130******00',
                  style: NewsTextStyle.style14NormalThrGrey,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                STButton(
                  icon: Icon(
                    STIcons.commonly_picture_outline,
                    color: ColorConfig.baseFirBule,
                  ),
                  text: '余额',
                  textStyle: NewsTextStyle.style14NormalBlack,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                ),
                Icon(
                  STIcons.direction_rightoutlined,
                  color: ColorConfig.firGrey,
                  size: 18,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            child: STButton(
              text: '确认交易',
              mainAxisSize: MainAxisSize.max,
              padding: EdgeInsets.symmetric(vertical: 6),
              radius: 8,
              onTap: confirmTap,
            ),
          )
        ],
      ),
    );
  }
}
