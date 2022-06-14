import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_select_icon.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class OrdersPayModel {
  final Widget? image;
  final String title;
  final String? value;

  OrdersPayModel({
    Key? key,
    this.image,
    required this.title,
    this.value,
  });
}

class OrdersPayWay extends StatefulWidget {
  const OrdersPayWay({
    Key? key,
    this.togglePayWaysTap,
  }) : super(key: key);

  final Function()? togglePayWaysTap;

  @override
  State<OrdersPayWay> createState() => _OrdersPayWayState();
}

class _OrdersPayWayState extends State<OrdersPayWay> {
  String _selectedValue = '';
  final _payWays = [
    OrdersPayModel(
        image: Icon(
          STIcons.commonly_picture_outline,
          color: ColorConfig.baseFirBule,
        ),
        title: '支付宝支付'),
    OrdersPayModel(
        image: Icon(
          STIcons.commonly_picture_outline,
          color: ColorConfig.baseFirBule,
        ),
        title: '微信支付'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = _payWays.first.value ?? _payWays.first.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: _payWays.map((e) => _buildRow(e)).toList(),
      ),
    );
  }

  Widget _buildRow(OrdersPayModel model) {
    return GestureDetector(
      onTap: () {
        _togglePayWay(model);
      },
      child: Container(
        margin: EdgeInsets.only(top: model != _payWays.first ? 18 : 0),
        child: Row(
          children: [
            if (model.image != null)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: model.image,
              ),
            Expanded(
              child: Text(
                model.title,
                style: NewsTextStyle.style14NormalBlack,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: ShoppingSelectIcon(
                selected: _selectedValue == (model.value ?? model.title),
                selectedTap: (_) {
                  _togglePayWay(model);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _togglePayWay(OrdersPayModel model) {
    if (_selectedValue != (model.value ?? model.title)) {
      _selectedValue = (model.value ?? model.title);
      setState(() {});
      if (widget.togglePayWaysTap == null) return;
      widget.togglePayWaysTap!();
    }
  }
}
