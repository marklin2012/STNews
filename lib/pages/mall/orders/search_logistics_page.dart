import 'package:flutter/material.dart';
import 'package:saturn/mobile/st_steps/st_shapes_dotted_line.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/shoppingCart/widgets/shopping_goods_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/utils+.dart';

class SearchLogisticsPage extends StatefulWidget {
  const SearchLogisticsPage({Key? key}) : super(key: key);

  @override
  State<SearchLogisticsPage> createState() => _SearchLogisticsPageState();
}

class _SearchLogisticsPageState extends State<SearchLogisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('物流信息'),
      ),
      body: Container(
        color: ColorConfig.backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildheader(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),
            SliverToBoxAdapter(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildheader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '已发货',
              style: NewsTextStyle.style16BoldBlack,
            ),
          ),
          ShoppingGoodsWidget(
            showPriceAndNumbers: false,
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogisticsInfo(),
          _buildReciverAddress(),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: STSteps(
              type: STStepsType.detail,
              lineType: STStepsLineType.dotted,
              detailWidth: NewsScale.screenW(context) - 100,
              fixed: 10,
              steps: [
                STStepItem(
                  title: '已发货 下午14:35',
                  info: '包裹正在等待揽收',
                  image: Icon(
                    STIcons.commonly_picture_outline,
                    color: ColorConfig.thrGrey,
                  ),
                  currentImage: Icon(
                    STIcons.commonly_picture_outline,
                    color: ColorConfig.baseFirBule,
                  ),
                ),
                STStepItem(
                  title: '已下单 上午 11:00',
                  info: '商品已下单',
                  image: Icon(
                    STIcons.commonly_picture_outline,
                    color: ColorConfig.thrGrey,
                  ),
                  currentImage: Icon(
                    STIcons.commonly_picture_outline,
                    color: ColorConfig.baseFirBule,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLogisticsInfo() {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConfig.thrGrey)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            child: Image(
              image: AssetImage('assets/images/default_logo.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 10),
            child: Text(
              '顺丰快递',
              style: NewsTextStyle.style14NormalBlack,
            ),
          ),
          // 物流单号
          Text(
            '20225437811785183672',
            style: NewsTextStyle.style14NormalBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildReciverAddress() {
    final _height = 78.0;
    final _topMargin = 20.0;
    return Container(
      height: _height,
      margin: EdgeInsets.only(top: _topMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 20,
                child: STShapesDottedLine(
                  margin: EdgeInsets.only(top: _topMargin + 6),
                  direction: Axis.vertical,
                  height: _height - _topMargin - 6 * 2,
                  width: 2,
                  color: ColorConfig.baseFirBule,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: Icon(
                      STIcons.commonly_picture_outline,
                      color: ColorConfig.baseFirBule,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '[收货地址] 北京市海淀区双清路双清路双清路双清路30号 187****0000',
                style: NewsTextStyle.style14NormalThrGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
