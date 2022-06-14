import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_action_sheet.dart';
import 'package:stnews/pages/common/scroll_header.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_attributes_picker.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_belong_stores.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_detail_attributes.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_detail_content.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_detail_footer.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_detail_nav_header.dart';
import 'package:stnews/pages/mall/orders/confirm_orders_page.dart';
import 'package:stnews/pages/mall/shoppingCart/shopping_cart_page.dart';
import 'package:stnews/pages/mall/stores/stores_page.dart';
import 'package:stnews/utils/st_routers.dart';

class GoodsDetailPage extends StatefulWidget {
  const GoodsDetailPage({Key? key}) : super(key: key);

  @override
  State<GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage> {
  late ScrollController _scrollController;
  late List<GoodsAttributeModel> _goodsAttributes;

  final GlobalKey _goodsKey = GlobalKey(debugLabel: 'goods'); // 商品的key
  final GlobalKey _commentsKey = GlobalKey(debugLabel: 'comments'); // 评论的key
  final GlobalKey _detailsKey = GlobalKey(debugLabel: 'details'); // 评论的key
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _goodsAttributes = [
      GoodsAttributeModel(
        name: '颜色分类',
        attributes: ['红色', '黑色', '白色', '金色', '银色', '绿色', '黄色', '紫色'],
      ),
      GoodsAttributeModel(
        name: '尺寸',
        attributes: ['S码', 'M码', 'L码', 'XL码', 'XXL码', 'XXXL码'],
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.backgroundColor,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 49),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                ScrollHeader(
                  minExtent: 44,
                  maxExtent: 360,
                  builder: (context, offset, _) {
                    return Container(
                      height: 360,
                      child: GoodsDetailNavHeader(
                        offset: offset,
                        navSelectedTap: (int index) {
                          debugPrint('navSelected: $index');
                          _scrollToPosition(index);
                        },
                      ),
                    );
                  },
                ),
                // 详情页内容
                SliverToBoxAdapter(
                  child: GoodsDetailContent(
                    key: _goodsKey,
                  ),
                ),
                // 详情页属性配置
                SliverToBoxAdapter(
                  child: GoodsDetailAttributes(
                    lists: _goodsAttributes,
                    goodsAttributesTap: (attributes) {
                      // 弹出选择框
                      NewsActionSheet.show(
                        context: context,
                        closeable: true,
                        isScrollControlled: true,
                        actions: [
                          GoodsAttributesPicker(
                            attributes: attributes,
                            closedTap: () {
                              NewsActionSheet.hide(context);
                            },
                          ),
                        ],
                      );
                    },
                    addressTap: () {
                      // 跳转到地址选择界面
                      STToast.show(context: context, message: '选择收货地址');
                    },
                  ),
                ),
                // 店铺评分与入口1
                SliverToBoxAdapter(
                  child: GoodsBelongStores(
                    title: 'Baby Star旗舰店',
                    rate: 3.5,
                    goStoresTap: () {
                      STRouters.push(context, StoresPage());
                    },
                  ),
                ),
                // 评价
                SliverToBoxAdapter(
                  child: Container(
                    key: _commentsKey,
                    color: ColorConfig.assistYellow,
                    height: 500,
                    child: Text('评价'),
                  ),
                ),
                // 详情
                SliverToBoxAdapter(
                  child: Container(
                    key: _detailsKey,
                    color: ColorConfig.assistGreen,
                    height: 500,
                    child: Text('详情'),
                  ),
                ),
              ],
            ),
          ),
          // 底部menu
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GoodsDetailFooter(
              items: [
                GoodsDetailItem(
                    title: '店铺',
                    onTap: () {
                      STRouters.push(context, StoresPage());
                    }),
                GoodsDetailItem(
                    title: '客服',
                    onTap: () {
                      STRouters.push(
                        context,
                        StoresPage(
                          index: 2,
                        ),
                      );
                    }),
                GoodsDetailItem(
                    title: '购物车',
                    onTap: () {
                      STRouters.push(context, ShoppingCartPage());
                    }),
              ],
              triggerAddShoppingCart: () {
                // 添加到购物车
              },
              triggerBuyNow: () {
                // 去确认订单页结算
                STRouters.push(context, ConfirmOrdersPage());
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 滑动到指定位置
  void _scrollToPosition(int index) {
    _findRenderObject(index);
    double animateH = 0.0;
    // 偏移量
    animateH = _scrollController.offset + _offset.dy;
    double _space = (MediaQuery.of(context).padding.top + 44.0);
    _scrollController.animateTo(animateH - _space,
        duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
  }

  /// 定位到具体的偏移量
  void _findRenderObject(int index) {
    GlobalKey _tempKey = _goodsKey;
    if (index == 1) {
      _tempKey = _commentsKey;
    } else if (index == 2) {
      _tempKey = _detailsKey;
    }
    RenderObject? renderobject = _tempKey.currentContext?.findRenderObject();
    if (renderobject != null && renderobject is RenderBox) {
      RenderBox renderBox = renderobject;
      _offset = renderBox.localToGlobal(Offset.zero);
    }
  }
}
