import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_goods_cell.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_select_icon.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class ShoppingStoresCell extends StatefulWidget {
  const ShoppingStoresCell({Key? key}) : super(key: key);

  @override
  State<ShoppingStoresCell> createState() => _ShoppingStoresCellState();
}

class _ShoppingStoresCellState extends State<ShoppingStoresCell> {
  late bool _storesAllSelected;

  @override
  void initState() {
    super.initState();
    _storesAllSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildGoods(),
        ],
      ),
    );
  }

  Widget _buildGoods() {
    return Container(
      height: 118 * 2 + 32 * (2 - 1) + 12,
      padding: EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ShoppingGoodsCell();
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 32,
            color: Colors.transparent,
          );
        },
        itemCount: 2,
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        // 跳转去店铺
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            // 店铺下全选与非全选
            ShoppingSelectIcon(
              selected: _storesAllSelected,
              padding: EdgeInsets.only(right: 12),
              selectedTap: (bool selected) {
                _storesAllSelected = selected;
                setState(() {});
              },
            ),
            // 店铺名
            Expanded(
              child: SizedBox(
                height: 22,
                child: Text(
                  'Baby Star旗舰店',
                  style: NewsTextStyle.style14NormalBlack,
                ),
              ),
            ),
            // 右箭头
            Icon(
              STIcons.direction_rightoutlined,
              color: ColorConfig.firGrey,
            ),
          ],
        ),
      ),
    );
  }
}
