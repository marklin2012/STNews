import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stnews/utils/news_text_style.dart';

class EmptyViewWidget extends StatefulWidget {
  const EmptyViewWidget({
    Key? key,
    this.fixTop,
    this.image,
    this.content,
    this.imageBGSize,
    this.textStyle,
    this.backgroundColor,
    this.isLoading = false,
    this.onTap,
  }) : super(key: key);

  /// 距离头部的高度
  final double? fixTop;

  /// 图片背景的宽高
  final double? imageBGSize;

  /// 图片子视图
  final Widget? image;

  /// 文字子视图
  final String? content;

  /// 文字的textStyle
  final TextStyle? textStyle;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否加载中
  final bool isLoading;

  /// 事件回调
  final Function()? onTap;

  const EmptyViewWidget.loading({
    Key? key,
    this.fixTop,
    this.imageBGSize,
    this.image,
    this.content = '内容加载中',
    this.textStyle,
    this.backgroundColor,
    this.isLoading = true,
    this.onTap,
  });

  @override
  _EmptyViewWidgetState createState() => _EmptyViewWidgetState();
}

const suffixLists = ['。', '。。', '。。。'];

class _EmptyViewWidgetState extends State<EmptyViewWidget> {
  late double _fixTop;
  late double _imageBGSize;
  late Color _backgroundColor;
  late TextStyle _textStyle;
  String? _content;
  ValueNotifier<String>? _contentNoti;
  Timer? _timer;
  int _currentTime = 0;

  @override
  void initState() {
    super.initState();
    _fixTop = widget.fixTop ?? 100;
    _imageBGSize = widget.imageBGSize ?? 80;
    _content = widget.content;
    _backgroundColor = widget.backgroundColor ?? Colors.white;
    _textStyle = widget.textStyle ?? NewsTextStyle.style16NormalSecGrey;
    if (widget.isLoading) {
      _contentNoti = ValueNotifier(_content ?? '内容加载中');
      _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        _currentTime += 1;
        int _currentIndex = _currentTime % 3;
        _contentNoti!.value = _content! + suffixLists[_currentIndex];
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _contentNoti?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        color: _backgroundColor,
        child: Column(
          children: [
            SizedBox(height: _fixTop),
            Container(
              width: _imageBGSize,
              height: _imageBGSize,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: widget.image,
            ),
            if (_content != null) SizedBox(height: 24),
            if (!widget.isLoading) Text(_content!, style: _textStyle),
            if (widget.isLoading)
              ValueListenableBuilder(
                valueListenable: _contentNoti!,
                builder: (context, String value, child) {
                  return Text(value, style: _textStyle);
                },
              )
          ],
        ),
      ),
    );
  }
}
