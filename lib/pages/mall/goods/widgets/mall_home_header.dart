import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/news_text_style.dart';

class MallHomeHeader extends StatefulWidget {
  const MallHomeHeader({
    Key? key,
    this.height,
    this.shoppingCartNum,
    this.triggerSearch,
    this.triggerOrders,
    this.triggerShppingCart,
  }) : super(key: key);

  final double? height;

  final int? shoppingCartNum;

  final Function? triggerSearch;

  final Function? triggerOrders;

  final Function? triggerShppingCart;

  @override
  State<MallHomeHeader> createState() => _MallHomeHeaderState();
}

class _MallHomeHeaderState extends State<MallHomeHeader> {
  late double _height;
  bool _shoppingCartIsClear = true;

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 44.0;
    if (widget.shoppingCartNum != null && widget.shoppingCartNum! > 0) {
      _shoppingCartIsClear = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      color: ColorConfig.primaryColor,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _searchTap,
              child: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: ColorConfig.fourGrey,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                      child: Hero(
                        tag: NewsHeroTags.searchHeaderTag,
                        child: Icon(
                          STIcons.commonly_search_outline,
                          color: ColorConfig.textFourColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        '搜索',
                        style: NewsTextStyle.style16NormalFourGrey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _ordersTap,
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 10, 10, 10),
              child: Icon(
                STIcons.commonly_order_outline,
              ),
            ),
          ),
          GestureDetector(
            onTap: _shoppingCartTap,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: _shoppingCartIsClear
                  ? Icon(
                      STIcons.commonly_shoppingcart_outline,
                    )
                  : STBadge(
                      value: widget.shoppingCartNum!.toString(),
                      child: Icon(
                        STIcons.commonly_shoppingcart_outline,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchTap() {
    if (widget.triggerSearch != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.triggerSearch!();
        },
        time: 600,
      );
    }
  }

  void _ordersTap() {
    if (widget.triggerOrders != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.triggerOrders!();
        },
        time: 600,
      );
    }
  }

  void _shoppingCartTap() {
    if (widget.triggerShppingCart != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.triggerShppingCart!();
        },
        time: 600,
      );
    }
  }
}
