import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

class MyOrdersHeader extends StatelessWidget {
  const MyOrdersHeader({
    Key? key,
    this.initIndex = 0,
    this.orderCurrentTap,
  }) : super(key: key);

  final int initIndex;

  final Function(int index)? orderCurrentTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      child: STMenu(
        items: [
          STMenuDataItem(title: '全部'),
          STMenuDataItem(title: '待付款'),
          STMenuDataItem(title: '待收货'),
          STMenuDataItem(title: '已完成'),
        ],
        initIndex: initIndex,
        type: STMenuType.underline,
        backgroundColor: ColorConfig.primaryColor,
        onTap: (int index) {
          if (initIndex == index) return;
          if (orderCurrentTap == null) return;
          orderCurrentTap!(index);
        },
      ),
    );
  }
}
