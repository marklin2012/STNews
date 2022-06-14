import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_detail_attributes.dart';
import 'package:stnews/pages/mall/goods/widgets/goods_show_price.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';

class GoodsAttributesPicker extends StatefulWidget {
  const GoodsAttributesPicker({
    Key? key,
    this.attributes,
    this.closedTap,
    this.confirmTap,
  }) : super(key: key);

  final List<GoodsAttributeModel>? attributes;

  final Function()? closedTap;

  final Function(List<String> selectedAttributes, int number)? confirmTap;

  @override
  State<GoodsAttributesPicker> createState() => _GoodsAttributesPickerState();
}

class _GoodsAttributesPickerState extends State<GoodsAttributesPicker> {
  late List<String> _selectedAttributes;

  @override
  void initState() {
    super.initState();
    _selectedAttributes = <String>[];
    if (widget.attributes != null) {
      for (var item in widget.attributes!) {
        _selectedAttributes.add(item.selectedAttribute ?? '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          _buildAttributes(),
          _buildBuyNumber(),
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: STButton(
              mainAxisSize: MainAxisSize.max,
              text: '确认',
              onTap: () {
                widget.confirmTap!([], 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyNumber() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '购买数量',
            style: NewsTextStyle.style16BoldDeepBlack,
          ),
          STStepper(
            value: 1,
            minValue: 1,
            maxValue: 9,
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 240,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final _temp = widget.attributes![index];
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorConfig.thrGrey),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _temp.name,
                    style: NewsTextStyle.style16BoldDeepBlack,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _temp.attributes!.map((e) {
                      final _isSelected = e == _selectedAttributes[index];
                      return GestureDetector(
                        onTap: () {
                          STDebounce().start(
                            key: '_GoodsAttributesPickerDebounceKey',
                            func: () {
                              _selectedOneAttribute(e, index);
                            },
                            time: 200,
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isSelected
                                ? ColorConfig.assistYellow
                                : ColorConfig.fourGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            e,
                            style: NewsTextStyle.style14NormalDeepBlack,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: widget.attributes?.length ?? 0,
      ),
    );
  }

  void _selectedOneAttribute(String attribute, int index) {
    final _current = _selectedAttributes[index];
    if (attribute != _current) {
      _selectedAttributes[index] = attribute;
      setState(() {});
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConfig.thrGrey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: 80,
            color: ColorConfig.baseFourBlue,
            child: Center(
              child: NewsImage.defaultCircle(height: 36),
            ),
          ),
          Expanded(child: _buildPrices()),
          STButton.icon(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(8),
            icon: Icon(
              STIcons.commonly_close_outline,
              size: 16,
              color: ColorConfig.textFirColor,
            ),
            onTap: () {
              widget.closedTap!();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrices() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoodsShowPrice(
            price: '289',
            smallFontSize: FONTSIZE14,
            fontSize: FONTSIZE18,
          ),
          GoodsShowOriginPrice(originPrice: '328'),
        ],
      ),
    );
  }
}
