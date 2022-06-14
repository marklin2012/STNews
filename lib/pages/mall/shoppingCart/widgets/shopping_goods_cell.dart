import 'package:flutter/material.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_goods_widget.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_select_icon.dart';

class ShoppingGoodsCell extends StatefulWidget {
  const ShoppingGoodsCell({Key? key}) : super(key: key);

  @override
  State<ShoppingGoodsCell> createState() => _ShoppingGoodsCellState();
}

class _ShoppingGoodsCellState extends State<ShoppingGoodsCell> {
  late bool _goodsSelected;

  @override
  void initState() {
    super.initState();
    _goodsSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // 选择商品
          ShoppingSelectIcon(
            selected: _goodsSelected,
            padding: EdgeInsets.only(right: 12),
            selectedTap: (bool selected) {
              _goodsSelected = selected;
              setState(() {});
            },
          ),
          Expanded(
            child: ShoppingGoodsWidget(),
          ),
        ],
      ),
    );
  }
}
