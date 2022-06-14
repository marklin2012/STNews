import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/pages/mall/orders/confirm_orders_page.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_stores_cell.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late ValueNotifier<bool> _manageNoti;
  late ValueNotifier<int> _numbersNoti;
  late List<int> _selected;

  @override
  void initState() {
    super.initState();
    final _isManaged = false;
    _manageNoti = ValueNotifier(_isManaged);
    final _goodsNumbers = 3;
    _numbersNoti = ValueNotifier(_goodsNumbers);
    _selected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: _numbersNoti,
            builder: (context, int numbers, _) {
              return Text('购物车($numbers)');
            }),
        actions: [
          ValueListenableBuilder(
              valueListenable: _manageNoti,
              builder: (context, bool value, _) {
                return STButton(
                  text: value ? '取消' : '管理',
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(16, 9, 16, 10),
                  textStyle: NewsTextStyle.style17NormalBlack,
                  onTap: _toggleManaged,
                );
              }),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            _buildStack(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 49.0 + 8.0),
      color: ColorConfig.backgroundColor,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ShoppingStoresCell();
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 16,
            color: Colors.transparent,
          );
        },
        itemCount: 2,
      ),
    );
  }

  Widget _buildStack() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder(
        valueListenable: _manageNoti,
        builder: (context, bool value, _) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 49,
            color: ColorConfig.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                STButton(
                  text: '全选',
                  backgroundColor: Colors.transparent,
                  icon: _buildIcon(),
                  textStyle: NewsTextStyle.style16NormalBlack,
                  padding: EdgeInsets.zero,
                  onTap: () {
                    _toggleAllSelected(_selected.length == _numbersNoti.value);
                  },
                ),
                // 合计
                if (!value) Expanded(child: _buildTotalPrice()),
                STButton(
                  text: value ? '删除' : '结算',
                  textStyle: NewsTextStyle.style16NormalWhite,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 3),
                  radius: 4.0,
                  backgroundColor:
                      value ? ColorConfig.assistRed : ColorConfig.baseFirBule,
                  onTap: () {
                    if (!value) {
                      STRouters.push(context, ConfirmOrdersPage());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    if (_selected.length == 0) {
      return Icon(
        Icons.check_box_outline_blank,
        color: ColorConfig.textThrColor,
      );
    } else if (_selected.length > 0 && _selected.length == _numbersNoti.value) {
      return Icon(
        Icons.check_box,
        color: ColorConfig.baseFirBule,
      );
    } else {
      return Icon(
        Icons.indeterminate_check_box,
        color: ColorConfig.baseFirBule,
      );
    }
  }

  Widget _buildTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '合计',
            style: NewsTextStyle.style16NormalBlack,
          ),
          GoodsShowPrice(
            price: '0',
            fontSize: FONTSIZE16,
            smallFontSize: FONTSIZE16,
          ),
        ],
      ),
    );
  }

  void _toggleManaged() {
    _manageNoti.value = !_manageNoti.value;
  }

  void _toggleAllSelected(bool isAllSelected) {
    _selected = [];
    if (!isAllSelected) {
      for (int i = 0; i < _numbersNoti.value; i++) {
        _selected.add(i);
      }
    }
    setState(() {});
  }
}
