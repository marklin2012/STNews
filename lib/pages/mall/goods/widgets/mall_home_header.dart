import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

class MallHomeHeader extends StatefulWidget {
  const MallHomeHeader({
    Key? key,
    this.height,
    this.controller,
    this.shoppingCartNum,
    this.searchTap,
    this.ordersTap,
    this.shoppingCartTap,
  }) : super(key: key);

  final double? height;

  final TextEditingController? controller;

  final int? shoppingCartNum;

  final Function(String)? searchTap;

  final Function? ordersTap;

  final Function? shoppingCartTap;

  @override
  State<MallHomeHeader> createState() => _MallHomeHeaderState();
}

class _MallHomeHeaderState extends State<MallHomeHeader> {
  late double _height;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _shoppingCartIsClear = true;

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 44.0;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    if (widget.shoppingCartNum != null && widget.shoppingCartNum! > 0) {
      _shoppingCartIsClear = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      color: ColorConfig.primaryColor,
      child: Row(
        children: [
          Expanded(
            child: STInput(
              height: 32.0,
              padding: EdgeInsets.zero,
              cursorHeight: 24.0,
              contentPadding: EdgeInsets.only(bottom: 18.0),
              prefixIcon: Icon(
                STIcons.commonly_search_outline,
                color: ColorConfig.textFourColor,
                size: 20.0,
              ),
              decoration: BoxDecoration(
                color: ColorConfig.fourGrey,
                borderRadius: BorderRadius.circular(4.0),
              ),
              placeholder: '搜索',
              controller: _controller,
              focusNode: _focusNode,
              inputType: TextInputType.text,
              onChanged: (String value) {
                if (value.isEmpty || value.length == 0) {
                  return;
                }
                _searchTap();
              },
              onSubmitted: (String value) {
                if (value.isEmpty || value.length == 0) {
                  return;
                }
                _searchTap();
              },
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
    if (_controller.text.isEmpty || _controller.text.length == 0) {
      STToast.show(context: context, message: '搜索内容不能为空');
      return;
    }
    if (widget.searchTap != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.searchTap!(_controller.text);
        },
        time: 600,
      );
    }
  }

  void _ordersTap() {
    if (widget.ordersTap != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.ordersTap!();
        },
        time: 600,
      );
    }
  }

  void _shoppingCartTap() {
    if (widget.shoppingCartTap != null) {
      STDebounce().start(
        key: '_mallHomeHeaderDebounceKey',
        func: () async {
          widget.shoppingCartTap!();
        },
        time: 600,
      );
    }
  }
}
