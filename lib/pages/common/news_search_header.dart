import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class NewsSearchHeader extends StatefulWidget {
  const NewsSearchHeader({
    Key? key,
    this.controller,
    this.searchTap,
    this.height,
    this.placeholder,
    this.btnTitle,
    this.debounceKey,
  }) : super(key: key);

  final String? debounceKey;

  final TextEditingController? controller;

  final Function(String)? searchTap;

  final double? height;

  final String? placeholder;

  final String? btnTitle;

  @override
  _NewsSearchHeaderState createState() => _NewsSearchHeaderState();
}

class _NewsSearchHeaderState extends State<NewsSearchHeader> {
  late double _height;
  late TextEditingController _controller;
  late String _placeholder;
  late String _btnTitle;
  late ValueNotifier<bool> _btnDisableNoti;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 44.0;
    _controller = widget.controller ?? TextEditingController();
    _placeholder = widget.placeholder ?? '请输入搜索内容';
    _btnTitle = widget.btnTitle ?? '搜索';
    _focusNode = FocusNode();
    _btnDisableNoti = ValueNotifier(true);

    _controller.addListener(() {
      if (_controller.text.isEmpty || _controller.text.length == 0) {
        _btnDisableNoti.value = true;
      } else {
        _btnDisableNoti.value = false;
      }
    });
    // // 激活搜索框
    Future.delayed(Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _btnDisableNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      color: ColorConfig.primaryColor,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              STRouters.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 13.0),
              child: Icon(
                STIcons.direction_leftoutlined,
                color: ColorConfig.textFirColor,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: STInput(
              height: 32.0,
              padding: EdgeInsets.zero,
              cursorHeight: 24.0,
              contentPadding: EdgeInsets.only(bottom: 18.0),
              prefixIcon: Hero(
                tag: NewsHeroTags.searchHeaderTag,
                child: Icon(
                  STIcons.commonly_search_outline,
                  color: ColorConfig.textFourColor,
                  size: 20.0,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConfig.fourGrey,
                borderRadius: BorderRadius.circular(4.0),
              ),
              placeholder: _placeholder,
              controller: _controller,
              focusNode: _focusNode,
              inputType: TextInputType.text,
              onChanged: (String value) {
                if (value.isEmpty || value.length == 0) {
                  return;
                }
                _search();
              },
              onSubmitted: (String value) {
                if (value.isEmpty || value.length == 0) {
                  return;
                }
                _search();
              },
            ),
          ),
          SizedBox(width: 8.0),
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: ValueListenableBuilder(
                valueListenable: _btnDisableNoti,
                builder: (BuildContext context, bool value, _) {
                  return STButton(
                    text: _btnTitle,
                    disabled: value,
                    textStyle: value
                        ? NewsTextStyle.style17NormalFourGrey
                        : NewsTextStyle.style17NormalFirBlue,
                    type: STButtonType.text,
                    onTap: _search,
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _search() {
    if (_controller.text.isEmpty || _controller.text.length == 0) {
      STToast.show(context: context, message: '搜索内容不能为空');
      return;
    }
    if (widget.searchTap != null) {
      STDebounce().start(
        key: widget.debounceKey,
        func: () async {
          widget.searchTap!(_controller.text);
        },
        time: 600,
      );
    }
  }
}
