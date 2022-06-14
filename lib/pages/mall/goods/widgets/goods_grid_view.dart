import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/mall/goods/widgets/mall_home_goods_cell.dart';

class GoodsGridView extends StatelessWidget {
  const GoodsGridView({
    Key? key,
    this.items,
    this.goodOnTap,
  }) : super(key: key);

  final List<MallHomeGoodsModel>? items;

  final Function(MallHomeGoodsModel?)? goodOnTap;

  @override
  Widget build(BuildContext context) {
    if (items == null || items!.length == 0) {
      return SliverToBoxAdapter(
        child: EmptyViewWidget(),
      );
    }
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 2,
      itemCount: items!.length,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(
              left: index % 2 == 0 ? 16.0 : 0,
              right: index % 2 == 0 ? 0 : 16.0),
          child: MallHomeGoodCell(
            model: items![index],
            onTap: (MallHomeGoodsModel? model) {
              if (goodOnTap == null) return;
              goodOnTap!(model);
            },
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(1);
      },
    );
  }
}
