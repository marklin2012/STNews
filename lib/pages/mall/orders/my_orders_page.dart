import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_action_sheet.dart';
import 'package:stnews/pages/mall/orders/pay_success_page.dart';
import 'package:stnews/pages/mall/orders/search_logistics_page.dart';
import 'package:stnews/pages/mall/orders/widgets/confirm_pay_sheet.dart';
import 'package:stnews/pages/mall/orders/widgets/my_oders_cell.dart';
import 'package:stnews/pages/mall/orders/widgets/my_orders_header.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late ValueNotifier<int> _currentOrderNoti;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    final _currentOrderIndex = 0;
    _currentOrderNoti = ValueNotifier(_currentOrderIndex);
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的订单'),
      ),
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
                valueListenable: _currentOrderNoti,
                builder: (context, int value, _) {
                  return MyOrdersHeader(
                    initIndex: value,
                    orderCurrentTap: (index) {
                      debugPrint('currentorderIndex: $index');
                      _currentOrderNoti.value = index;
                      _controller.jumpToPage(index);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return _buildList();
      },
      itemCount: 4,
      onPageChanged: (int index) {
        _currentOrderNoti.value = index;
      },
    );
  }

  Widget _buildList() {
    return Container(
      margin: EdgeInsets.only(top: 44),
      padding: EdgeInsets.only(top: 8),
      color: ColorConfig.backgroundColor,
      child: ListView.separated(
        itemBuilder: (context, index) {
          var _status = MyOrdersStatus.other;
          if (index == 0) {
            _status = MyOrdersStatus.waitDelivery;
          } else if (index == 1) {
            _status = MyOrdersStatus.finished;
          } else {
            _status = MyOrdersStatus.waitPaymet;
          }
          return MyOrdersCell(
            status: _status,
            actionCallBack: (MyOrdersStatus status, int index) {
              _cellActions(status, index);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 12,
            color: Colors.transparent,
          );
        },
        itemCount: 4,
      ),
    );
  }

  void _cellActions(MyOrdersStatus status, int index) {
    if (status == MyOrdersStatus.waitPaymet && index == 0) {
      // 取消订单
      NewsActionSheet.show(
        context: context,
        actions: [
          Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: ColorConfig.thrGrey)),
            ),
            child: Text(
              '取消后无法查看订单，确认要取消吗？',
              style: NewsTextStyle.style16NormalSecGrey,
            ),
          ),
          STButton(
            text: '取消订单',
            type: STButtonType.text,
            mainAxisSize: MainAxisSize.max,
            textStyle: NewsTextStyle.style16NormalBlack,
            padding: EdgeInsets.symmetric(vertical: 13),
            onTap: () {},
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: STButton(
              text: '去支付',
              mainAxisSize: MainAxisSize.max,
              padding: EdgeInsets.symmetric(vertical: 9),
              textStyle: NewsTextStyle.style18BoldBlack,
              backgroundColor: ColorConfig.fourGrey,
              radius: 12,
              onTap: () {},
            ),
          ),
        ],
      );
    } else if (status == MyOrdersStatus.waitPaymet && index == 1) {
      // 立即支付
      NewsActionSheet.show(
        context: context,
        closeable: true,
        actions: [
          ConfirmPaySheet(
            closeTap: () {
              NewsActionSheet.hide(context);
            },
            confirmTap: () {
              STRouters.push(context, PaySuccessPage());
            },
          ),
        ],
      );
    } else if (status == MyOrdersStatus.waitDelivery && index == 0) {
      // 查看物流
      STRouters.push(context, SearchLogisticsPage());
    } else if (status == MyOrdersStatus.waitDelivery && index == 1) {
      // 确认收货
    } else if (status == MyOrdersStatus.finished && index == 0) {
      // 删除订单

    } else if (status == MyOrdersStatus.finished && index == 1) {
      // 加入购物车
    }
  }
}
