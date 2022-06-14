import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/address/widgets/address_cell.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/shapes_parallelogram.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/utils+.dart';

class AddressChoose extends StatelessWidget {
  const AddressChoose({
    Key? key,
    this.model,
    this.choosedAddressTap,
  }) : super(key: key);

  final AddressModel? model;

  final Function()? choosedAddressTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (choosedAddressTap == null) return;
        choosedAddressTap!();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: ColorConfig.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: NewsBoxShadow.goodsShadaw,
        ),
        child: Column(
          children: [
            model == null ? _buildEmptyContent() : _buildContent(),
            _buildBottom(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    final _index = ((NewsScale.screenW(context) - 16) / 20.0).floor();
    final _lists = <Widget>[];
    for (int i = 0; i < _index; i++) {
      final _widget = Container(
        margin: EdgeInsets.only(right: 2),
        child: CustomPaint(
          painter: ShapeParallelogram(
            color: i % 2 == 0 ? ColorConfig.thrGrey : ColorConfig.baseFourBlue,
          ),
          child: SizedBox(
            height: 4,
            width: 18,
          ),
        ),
      );
      _lists.add(_widget);
    }
    return Container(
      height: 4,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        children: _lists,
      ),
    );
  }

  Widget _buildEmptyContent() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '添加收货地址，让快递到家～',
              style: NewsTextStyle.style16NormalBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              STIcons.direction_rightoutlined,
              size: 18,
              color: ColorConfig.firGrey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            STIcons.commonly_picture_outline,
            color: ColorConfig.baseFirBule,
          ),
          Expanded(child: _buildAddress()),
          Icon(
            STIcons.direction_rightoutlined,
            color: ColorConfig.firGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '北京市海淀区双清路双清路双清路双清路双清路30号',
            style: NewsTextStyle.style16BoldBlack,
            maxLines: 2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '林女士 18700008998',
              style: NewsTextStyle.style14NormalThrGrey,
            ),
          )
        ],
      ),
    );
  }
}
