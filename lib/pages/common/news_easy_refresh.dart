import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_footer.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_header.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';

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
  final Future<ResultRefreshData> Function()? onLoad;
  final Widget child;

  @override
  _NewsEasyRefreshState createState() => _NewsEasyRefreshState();
}

class _NewsEasyRefreshState extends State<NewsEasyRefresh> {
  late EasyRefreshController _controller;
  late bool _hasHeader;
  late bool _hasFooter;
  NewsRefreshHeader? _header;
  NewsRefreshFooter? _footer;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _hasHeader = widget.hasHeader ?? false;
    _hasFooter = widget.hasFooter ?? false;
    if (_hasHeader)
      _header = NewsRefreshHeader(
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
      _footer = NewsRefreshFooter(
        loadText: '上拉加载',
        loadReadyText: '松开加载',
        loadingText: '正在加载更多内容...',
        loadedText: '完成加载',
        loadFailedText: '加载失败,请点击重试',
        noMoreText: '无更多数据',
        showInfo: false,
        enableInfiniteLoad: false,
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
              _controller.resetLoadState();
            }
          : null,
      onLoad: _hasFooter
          ? () async {
              ResultRefreshData data = ResultRefreshData.normal();
              if (widget.onLoad != null) {
                data = await widget.onLoad!();
              }
              _controller.finishLoad(
                  success: data.success, noMore: !data.hasMore);
            }
          : null,
      child: widget.child,
    );
  }
}
