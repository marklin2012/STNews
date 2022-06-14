import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

class GoodsAttributeModel {
  final String name;
  final String? selectedAttribute;
  final List<String>? attributes;

  const GoodsAttributeModel({
    Key? key,
    required this.name,
    this.selectedAttribute,
    this.attributes,
  });
}

class GoodsAddressModel {
  final String? sendAddress;
  final String? reciverAddress;
  final String? express;

  const GoodsAddressModel({
    Key? key,
    this.sendAddress,
    this.reciverAddress,
    this.express,
  });
}

class GoodsDetailAttributes extends StatelessWidget {
  const GoodsDetailAttributes({
    Key? key,
    required this.lists,
    this.addressModel = const GoodsAddressModel(
      sendAddress: '浙江杭州',
      reciverAddress: '北京市 朝阳区 杏林街道 XXX小区X栋XXXX',
    ),
    this.goodsAttributesTap,
    this.addressTap,
  }) : super(key: key);

  final List<GoodsAttributeModel> lists;

  final GoodsAddressModel? addressModel;

  final Function(List<GoodsAttributeModel>)? goodsAttributesTap;

  final Function()? addressTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: NewsBoxShadow.goodsShadaw,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (goodsAttributesTap == null) return;
              goodsAttributesTap!(lists);
            },
            child: _buildAttributes(),
          ),
          GestureDetector(
            onTap: () {
              if (addressTap == null) return;
              addressTap!();
            },
            child: _buildAddress(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 24),
          child: Text(
            '选择',
            style: NewsTextStyle.style12NormalSecGrey,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAttributeName(),
              _buildSelectedAttribute(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeName() {
    String _attributeNames = '';
    for (int i = 0; i < lists.length; i++) {
      final _tempM = lists[i];
      if (i == lists.length - 1) {
        _attributeNames += '${_tempM.name}';
      } else {
        _attributeNames += ' ${_tempM.name} / ';
      }
    }
    return Text(
      _attributeNames,
      style: NewsTextStyle.style12NormalBlack,
    );
  }

  Widget _buildSelectedAttribute() {
    return Container(
      padding: EdgeInsets.zero,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 5.0,
        children: lists.map((e) {
          final _temp = e;
          var _tempStr = _temp.selectedAttribute ?? '';
          if (_temp.selectedAttribute == null) {
            _tempStr = '共${_temp.attributes?.length}${_temp.name}可选';
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 20,
            decoration: BoxDecoration(
              color: ColorConfig.fourGrey,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              _tempStr,
              style: NewsTextStyle.style12NormalSecGrey,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: Text(
              '发货',
              style: NewsTextStyle.style12NormalSecGrey,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (addressModel?.sendAddress != null)
                  Text(
                    addressModel!.sendAddress!,
                    style: NewsTextStyle.style12NormalBlack,
                  ),
                if (addressModel?.reciverAddress != null)
                  Text(
                    addressModel!.reciverAddress!,
                    style: NewsTextStyle.style12NormalThrGrey,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
