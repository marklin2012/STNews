import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

enum MyOrdersStatus {
  waitPaymet,
  waitDelivery,
  finished,
  other,
}

class MyOrdersCell extends StatelessWidget {
  const MyOrdersCell({
    Key? key,
    this.status = MyOrdersStatus.other,
    this.actionCallBack,
  }) : super(key: key);

  final MyOrdersStatus status;
  // 回调
  final Function(MyOrdersStatus status, int index)? actionCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: [
          _getHeaders(),
          _getCenters(),
          _getfooters(),
        ],
      ),
    );
  }

  Widget _getHeaders() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Baby Star旗舰店',
            style: NewsTextStyle.style14NormalBlack,
          ),
          // 订单状态
          _buildHeaderStatus(),
        ],
      ),
    );
  }

  Widget _buildHeaderStatus() {
    if (status == MyOrdersStatus.waitPaymet) {
      return Text(
        '剩30分自动关闭',
        style: NewsTextStyle.style14NormalRed,
      );
    } else if (status == MyOrdersStatus.finished) {
      return Text(
        '交易成功',
        style: NewsTextStyle.style14NormalRed,
      );
    }
    return Text(
      '退款成功',
      style: NewsTextStyle.style14NormalYellow,
    );
  }

  Widget _getCenters() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getImage(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  '爱只为你音乐盒木质八音盒旋盒音乐盒木质八音盒旋盒',
                  style: NewsTextStyle.style14NormalBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 已选属性
                _getSelectedAttributes(),
                // 价格
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: GoodsShowPrice(
                    price: '289',
                    smallFontSize: FONTSIZE14,
                    fontSize: FONTSIZE16,
                    fontWeight: FONTWEIGHT400,
                    fontColor: ColorConfig.textFirColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getImage() {
    return Container(
      margin: EdgeInsets.only(right: 12),
      height: 100,
      width: 100,
      color: ColorConfig.baseFourBlue,
      child: Center(
        child: NewsImage.defaultCircle(height: 44),
      ),
    );
  }

  Widget _getSelectedAttributes() {
    // 可多个属性
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 5.0,
        children: ['盒装', '柠檬味'].map((e) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 20,
            decoration: BoxDecoration(
              color: ColorConfig.fourGrey,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              e,
              style: NewsTextStyle.style12NormalSecGrey,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getfooters() {
    // 根据订单状态的不同，显示不同的操作按钮
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _buildActions(),
      ),
    );
  }

  List<Widget> _buildActions() {
    final _lists = <Widget>[];
    if (status == MyOrdersStatus.waitPaymet) {
      _lists.add(
        STButton(
          text: '取消订单',
          textStyle: NewsTextStyle.style14NormalSecGrey,
          type: STButtonType.outline,
          radius: 4,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          borderColor: ColorConfig.thrGrey,
          onTap: () {
            _acitonTap(0);
          },
        ),
      );
      _lists.add(
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: STButton(
            text: '立即支付',
            textStyle: NewsTextStyle.style14NormalWhite,
            radius: 4,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            onTap: () {
              _acitonTap(1);
            },
          ),
        ),
      );
    } else if (status == MyOrdersStatus.waitDelivery) {
      _lists.add(
        STButton(
          text: '查看物流',
          textStyle: NewsTextStyle.style14NormalSecGrey,
          type: STButtonType.outline,
          radius: 4,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          borderColor: ColorConfig.thrGrey,
          onTap: () {
            _acitonTap(0);
          },
        ),
      );
      _lists.add(
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: STButton(
            text: '确认收货',
            textStyle: NewsTextStyle.style14NormalRed,
            type: STButtonType.outline,
            radius: 4,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            borderColor: ColorConfig.thrGrey,
            onTap: () {
              _acitonTap(1);
            },
          ),
        ),
      );
    } else if (status == MyOrdersStatus.finished) {
      _lists.add(
        STButton(
          text: '删除订单',
          textStyle: NewsTextStyle.style14NormalSecGrey,
          type: STButtonType.outline,
          radius: 4,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          borderColor: ColorConfig.thrGrey,
          onTap: () {
            _acitonTap(0);
          },
        ),
      );
      _lists.add(
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: STButton(
            text: '加入购物车',
            textStyle: NewsTextStyle.style14NormalRed,
            type: STButtonType.outline,
            radius: 4,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            borderColor: ColorConfig.thrGrey,
            onTap: () {
              _acitonTap(1);
            },
          ),
        ),
      );
    }
    return _lists;
  }

  void _acitonTap(int index) {
    if (actionCallBack == null) return;
    actionCallBack!(status, index);
  }
}
