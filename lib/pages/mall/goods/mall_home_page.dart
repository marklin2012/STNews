import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saturn/utils/blank_keyborad.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_good_cell.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_header.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_menu.dart';

class MallHomePage extends StatefulWidget {
  const MallHomePage({Key? key}) : super(key: key);

  @override
  State<MallHomePage> createState() => _MallHomePageState();
}

class _MallHomePageState extends State<MallHomePage> {
  late TextEditingController _searchController;
  List<MallHomeGoodModel> _goodLists = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _setMock();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setMock() {
    for (int i = 0; i < 10; i++) {
      final _model = MallHomeGoodModel(
        id: i.toString(),
        title: '爱只为你 音乐盒木质八音盒旋转木马',
        presentPrice: '289.0',
      );
      if (i % 2 == 0) {
        _model.type = MallHomeGoodTagType.fullMinus;
      } else {
        _model.type = MallHomeGoodTagType.seckill;
        _model.originalPrice = '320';
      }
      if (i == 2) {
        _model.type = MallHomeGoodTagType.none;
      }
      _goodLists.add(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        title: MallHomeHeader(
          controller: _searchController,
          searchTap: (String search) {},
          ordersTap: () {},
          shoppingCartTap: () {},
        ),
      ),
      body: BlankPutKeyborad(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MallHomeMenu(),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 2,
      itemCount: _goodLists.length,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(
              left: index % 2 == 0 ? 16.0 : 0,
              right: index % 2 == 0 ? 0 : 16.0),
          child: MallHomeGoodCell(
            model: _goodLists[index],
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(1);
      },
    );
  }
}
