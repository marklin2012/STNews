import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:stnews/pages/common/color_config.dart';

class NewsEasyRefresh extends StatefulWidget {
  const NewsEasyRefresh({
    Key? key,
    this.onRefresh,
    this.onLoad,
    required this.child,
    this.hasHeader,
    this.hasFooter,
  }) : super(key: key);

  final bool? hasHeader;
  final bool? hasFooter;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoad;
  final Widget child;

  @override
  _NewsEasyRefreshState createState() => _NewsEasyRefreshState();
}

class _NewsEasyRefreshState extends State<NewsEasyRefresh> {
  late EasyRefreshController _controller;
  late bool _hasHeader;
  late bool _hasFooter;
  ClassicalHeader? _header;
  ClassicalFooter? _footer;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _hasHeader = widget.hasHeader ?? false;
    _hasFooter = widget.hasFooter ?? false;
    if (_hasHeader)
      _header = ClassicalHeader(
        refreshText: '下拉刷新',
        refreshReadyText: '松开刷新',
        refreshingText: '加载中...',
        refreshedText: '完成刷新',
        refreshFailedText: '刷新失败',
        showInfo: false,
        enableHapticFeedback: false,
        textColor: ColorConfig.textThrColor,
      );
    if (_hasFooter)
      _footer = ClassicalFooter(
        loadText: '上拉加载',
        loadReadyText: '松开加载',
        loadingText: '加载中...',
        loadedText: '完成加载',
        loadFailedText: '加载更多失败',
        noMoreText: '无更多数据',
        showInfo: false,
        enableHapticFeedback: false,
        textColor: ColorConfig.textThrColor,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      header: _header,
      footer: _footer,
      onRefresh: _hasHeader
          ? () async {
              if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
              _controller.finishRefresh();
            }
          : null,
      onLoad: _hasFooter
          ? () async {
              if (widget.onLoad != null) {
                widget.onLoad!();
              }
              _controller.finishLoad();
            }
          : null,
      child: widget.child,
    );
  }
}
