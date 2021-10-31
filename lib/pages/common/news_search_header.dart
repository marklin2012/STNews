import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class NewsSearchHeader extends StatefulWidget {
  const NewsSearchHeader({
    Key? key,
    required this.heroTag,
    this.controller,
    this.searchTap,
    this.height,
    this.placeholder,
    this.btnTitle,
    this.debounceKey,
  }) : super(key: key);

  final String heroTag;

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

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 44.0;
    _controller = widget.controller ?? TextEditingController();
    _placeholder = widget.placeholder ?? '请输入搜索内容';
    _btnTitle = widget.btnTitle ?? '搜索';
    _btnDisableNoti = ValueNotifier(true);

    _controller.addListener(() {
      if (_controller.text.isEmpty || _controller.text.length == 0) {
        _btnDisableNoti.value = true;
      } else {
        _btnDisableNoti.value = false;
      }
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
                tag: widget.heroTag,
                child: Icon(
                  STIcons.commonly_search,
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
              onChanged: (String value) {
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
                    textStyle: NewsTextStyle.style17NormalFirBlue,
                    type: STButtonType.text,
                    backgroundColor: Colors.transparent,
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
      STToast.show(context: context, message: '搜素内容不能为空');
      return;
    }
    if (widget.searchTap != null) {
      STDebounce().start(
        key: widget.debounceKey ?? widget.heroTag,
        func: () async {
          widget.searchTap!(_controller.text);
        },
        time: 600,
      );
    }
  }
}