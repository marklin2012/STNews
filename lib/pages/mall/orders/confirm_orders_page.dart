import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/orders/widgets/address_choose.dart';
import 'package:stnews/pages/mall/orders/widgets/orders_goods.dart';
import 'package:stnews/pages/mall/orders/widgets/orders_pay_way.dart';
import 'package:stnews/pages/mall/orders/widgets/orders_price_total.dart';
import 'package:stnews/utils/news_text_style.dart';

class ConfirmOrdersPage extends StatefulWidget {
  const ConfirmOrdersPage({Key? key}) : super(key: key);

  @override
  State<ConfirmOrdersPage> createState() => _ConfirmOrdersPageState();
}

class _ConfirmOrdersPageState extends State<ConfirmOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单确认'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildFooter(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.only(bottom: 49),
      color: ColorConfig.backgroundColor,
      child: CustomScrollView(
        slivers: [
          // 地址栏
          SliverToBoxAdapter(
            child: AddressChoose(),
          ),
          // 商品列表
          SliverToBoxAdapter(
            child: OrdersGoods(),
          ),
          // 金额优惠运费合计
          SliverToBoxAdapter(
            child: OrdersPriceTotal(),
          ),
          // 支付方式
          SliverToBoxAdapter(
            child: OrdersPayWay(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 49,
      color: ColorConfig.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '合计',
            style: NewsTextStyle.style16NormalBlack,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '￥289',
                style: NewsTextStyle.style16BoldRed,
              ),
            ),
          ),
          STButton(
            disabled: true,
            radius: 2,
            text: '提交订单',
            textStyle: NewsTextStyle.style14NormalWhite,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
