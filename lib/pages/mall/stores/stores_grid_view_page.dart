import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/goods_detail_page.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_grid_view.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_goods_cell.dart';
import 'package:stnews/pages/mall/mock/goods_lists_mock.dart';
import 'package:stnews/utils/st_routers.dart';

class StoresGridViewPage extends StatefulWidget {
  const StoresGridViewPage({Key? key}) : super(key: key);

  @override
  State<StoresGridViewPage> createState() => _StoresGridViewPageState();
}

class _StoresGridViewPageState extends State<StoresGridViewPage> {
  late List<MallHomeGoodsModel> _goodLists;

  @override
  void initState() {
    super.initState();
    _goodLists = GoodsListsMock.setMock();
  }

  @override
  Widget build(BuildContext context) {
    return BlankPutKeyborad(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: STMenu(
              items: [
                STMenuDataItem(title: '全部'),
                STMenuDataItem(title: '推荐'),
                STMenuDataItem(title: '新品'),
              ],
              type: STMenuType.underline,
              backgroundColor: ColorConfig.primaryColor,
              onTap: (int index) {},
            ),
          ),
          GoodsGridView(
            items: _goodLists,
            goodOnTap: (MallHomeGoodsModel? model) {
              STRouters.push(context, GoodsDetailPage());
            },
          ),
        ],
      ),
    );
  }
}
