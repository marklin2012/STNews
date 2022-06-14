import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_belong_stores.dart';
import 'package:stnews/pages/mall/stores/stores_category_detail_page.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/utils+.dart';

class StoresCategoryPage extends StatefulWidget {
  const StoresCategoryPage({Key? key}) : super(key: key);

  @override
  State<StoresCategoryPage> createState() => _StoresCategoryPageState();
}

const _dataLists = ['短袖T恤', '长袖T恤', '卫衣', '休闲裤', '连衣裙', '套装'];

class _StoresCategoryPageState extends State<StoresCategoryPage> {
  late bool _isFavourited;

  @override
  void initState() {
    super.initState();
    _isFavourited = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlankPutKeyborad(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        color: ColorConfig.backgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: GoodsBelongStores(
                rate: 3.5,
                title: 'Baby Star旗舰店',
                isFavourited: _isFavourited,
                type: GoodsBelongStoresType.isFavourited,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: NewsBoxShadow.goodsShadaw,
                  color: ColorConfig.primaryColor,
                ),
                favouritedTap: (bool isFavourited) {
                  _isFavourited = isFavourited;
                  setState(() {});
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('点击了$index');
                        STRouters.push(
                          context,
                          StoresCategoryDetailPage(),
                        );
                      },
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: ColorConfig.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: NewsBoxShadow.goodsShadaw,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dataLists[index],
                              style: NewsTextStyle.style16NormalBlack,
                            ),
                            Icon(
                              STIcons.direction_rightoutlined,
                              color: ColorConfig.firGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _dataLists.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
