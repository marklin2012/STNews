import 'package:flutter/material.dart';
import 'package:saturn/utils/blank_keyborad.dart';
import 'package:stnews/models/test_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/goods_detail_page.dart';
import 'package:stnews/pages/mall/goods/search_goods_page.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_grid_view.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_goods_cell.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_header.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_menu.dart';
import 'package:stnews/pages/mall/mock/goods_lists_mock.dart';
import 'package:stnews/pages/mall/orders/my_orders_page.dart';
import 'package:stnews/pages/mall/shoppingCart/shopping_cart_page.dart';
import 'package:stnews/utils/st_routers.dart';

class MallHomePage extends StatefulWidget {
  const MallHomePage({Key? key}) : super(key: key);

  @override
  State<MallHomePage> createState() => _MallHomePageState();
}

class _MallHomePageState extends State<MallHomePage> {
  late TextEditingController _searchController;
  List<MallHomeGoodsModel> _goodLists = [];

  @override
  void initState() {
    super.initState();
    getGoodsMode();
    _searchController = TextEditingController();
    _goodLists = GoodsListsMock.setMock();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        title: MallHomeHeader(
          triggerSearch: () {
            STRouters.push(context, SearchGoodsPage());
          },
          triggerOrders: () {
            STRouters.push(context, MyOrdersPage());
          },
          triggerShppingCart: () {
            STRouters.push(context, ShoppingCartPage());
          },
        ),
      ),
      body: BlankPutKeyborad(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MallHomeMenu(),
            ),
            GoodsGridView(
              items: _goodLists,
              goodOnTap: (MallHomeGoodsModel? model) {
                STRouters.push(context, GoodsDetailPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
