import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/st_scale.dart';

enum MallHomeGoodTagType {
  none,
  seckill,
  fullMinus,
}

class MallHomeGoodModel {
  String? id;
  List<String>? images;
  List<String>? visibles;
  String? title;
  MallHomeGoodTagType? type;
  String? originalPrice;
  String? presentPrice;

  MallHomeGoodModel({
    this.id,
    this.type,
    this.originalPrice,
    this.presentPrice,
    this.images,
    this.visibles,
    this.title,
  });
}

class MallHomeGoodCell extends StatelessWidget {
  const MallHomeGoodCell({Key? key, this.model, this.onTap}) : super(key: key);

  final MallHomeGoodModel? model;

  final Function(MallHomeGoodModel? selModel)? onTap;

  @override
  Widget build(BuildContext context) {
    if (model == null) return Container();
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: InkWell(
        highlightColor: ColorConfig.fourGrey,
        onTap: () {
          if (onTap != null) {
            onTap!(model);
          }
        },
        child: Card(
          elevation: 0,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: ColorConfig.backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildTagAndTitle(),
          if (model?.presentPrice != null)
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                '￥${model?.presentPrice}',
                style: TextStyle(
                  color: ColorConfig.assistRed,
                  fontSize: 17.0,
                ),
              ),
            ),
          if (model?.originalPrice != null)
            Text(
              '￥${model?.originalPrice}',
              style: TextStyle(
                color: ColorConfig.textFourColor,
                fontSize: 11.0,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: NewsScale.sw(170, context),
          height: NewsScale.sh(180, context),
          decoration: BoxDecoration(
            color: ColorConfig.baseFourBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          ),
          child: NewsImage.networkImage(
            path: (model?.images != null && model!.images!.length != 0)
                ? model?.images?.first
                : null,
            defaultChild: NewsImage.defaultCircle(height: 80.0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildTagAndTitle() {
    Widget _child = Text(
      model?.title ?? '',
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
    if (model?.type == MallHomeGoodTagType.seckill ||
        model?.type == MallHomeGoodTagType.fullMinus) {
      String _textString = '';
      Color _textBGColor;
      if (model?.type == MallHomeGoodTagType.seckill) {
        _textString = ' 秒杀 ';
        _textBGColor = ColorConfig.assistRed;
      } else {
        _textString = ' 立减10 ';
        _textBGColor = ColorConfig.assistYellow;
      }
      _child = RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14.0),
          children: [
            TextSpan(
              text: _textString,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.0,
                backgroundColor: _textBGColor,
                fontFamily: 'PingFang',
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: model?.title,
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(top: 4.0),
      alignment: Alignment.center,
      child: _child,
    );
  }
}
