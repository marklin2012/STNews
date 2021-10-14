import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/// 经典Footer
class NewsRefreshFooter extends Footer {
  /// Key
  final Key? key;

  /// 方位
  final AlignmentGeometry? alignment;

  /// 提示加载文字
  final String? loadText;

  /// 准备加载文字
  final String? loadReadyText;

  /// 正在加载文字
  final String? loadingText;

  /// 加载完成文字
  final String? loadedText;

  /// 加载失败文字
  final String? loadFailedText;

  /// 没有更多文字
  final String? noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String? infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  NewsRefreshFooter({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration? completeDuration = const Duration(seconds: 1),
    bool enableInfiniteLoad = true,
    bool enableHapticFeedback = true,
    bool overScroll = false,
    bool safeArea = true,
    EdgeInsets? padding,
    this.key,
    this.alignment,
    this.loadText,
    this.loadReadyText,
    this.loadingText,
    this.loadedText,
    this.loadFailedText,
    this.noMoreText,
    this.showInfo: true,
    this.infoText,
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableInfiniteLoad: enableInfiniteLoad,
          enableHapticFeedback: enableHapticFeedback,
          overScroll: overScroll,
          safeArea: safeArea,
          padding: padding,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return NewsRefreshFooterWidget(
      key: key,
      classicalFooter: this,
      loadState: loadState,
      pulledExtent: pulledExtent,
      loadTriggerPullDistance: loadTriggerPullDistance,
      loadIndicatorExtent: loadIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteLoad: enableInfiniteLoad,
      success: success,
      noMore: noMore,
    );
  }
}

/// 经典Footer组件
class NewsRefreshFooterWidget extends StatefulWidget {
  final NewsRefreshFooter classicalFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration? completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;

  NewsRefreshFooterWidget(
      {Key? key,
      required this.loadState,
      required this.classicalFooter,
      required this.pulledExtent,
      required this.loadTriggerPullDistance,
      required this.loadIndicatorExtent,
      required this.axisDirection,
      required this.float,
      this.completeDuration,
      required this.enableInfiniteLoad,
      required this.success,
      required this.noMore})
      : super(key: key);

  @override
  NewsRefreshFooterWidgetState createState() => NewsRefreshFooterWidgetState();
}

class NewsRefreshFooterWidgetState extends State<NewsRefreshFooterWidget>
    with TickerProviderStateMixin<NewsRefreshFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  /// 文本
  String get _loadText {
    return widget.classicalFooter.loadText ?? 'Push to load';
  }

  String get _loadReadyText {
    return widget.classicalFooter.loadReadyText ?? 'Release to load';
  }

  String get _loadingText {
    return widget.classicalFooter.loadingText ?? 'Loading...';
  }

  String get _loadedText {
    return widget.classicalFooter.loadedText ?? 'Load completed';
  }

  String get _loadFailedText {
    return widget.classicalFooter.loadFailedText ?? 'Load failed';
  }

  /// 没有更多文字
  String get _noMoreText {
    return widget.classicalFooter.noMoreText ?? 'No more';
  }

  String get _infoText {
    return widget.classicalFooter.infoText ?? 'Update at %T';
  }

  // 动画
  late AnimationController _readyController;
  late Animation<double> _readyAnimation;
  late AnimationController _restoreController;
  late Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 显示文字
  String get _showText {
    if (widget.noMore && widget.success) return _noMoreText;
    if (widget.enableInfiniteLoad) {
      if (widget.loadState == LoadMode.loaded ||
          widget.loadState == LoadMode.inactive ||
          widget.loadState == LoadMode.drag) {
        return _finishedText;
      } else {
        return _loadingText;
      }
    }
    switch (widget.loadState) {
      case LoadMode.load:
        return _loadingText;
      case LoadMode.armed:
        return _loadingText;
      case LoadMode.loaded:
        return _finishedText;
      case LoadMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _loadReadyText;
        } else {
          return _loadText;
        }
    }
  }

  // 加载结束文字
  String get _finishedText {
    if (!widget.success) return _loadFailedText;
    if (widget.noMore) return _noMoreText;
    return _loadedText;
  }

  // 加载结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    return Icons.done;
  }

  // 更新时间
  late DateTime _dateTime;

  // 获取更多信息
  String get _infoTextStr {
    if (widget.loadState == LoadMode.loaded) {
      _dateTime = DateTime.now();
    }
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return _infoText.replaceAll(
        "%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  void initState() {
    super.initState();
    // 初始化时间
    _dateTime = DateTime.now();
    // 初始化动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发加载距离
    overTriggerDistance = widget.loadState != LoadMode.inactive &&
        widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isReverse ? 0.0 : null,
          bottom: isReverse ? 0.0 : null,
          left: 0.0,
          right: 0.0,
          child: Container(
            alignment: widget.classicalFooter.alignment ??
                (!isReverse ? Alignment.topCenter : Alignment.bottomCenter),
            width: double.infinity,
            height: widget.loadIndicatorExtent > widget.pulledExtent
                ? widget.loadIndicatorExtent
                : widget.pulledExtent,
            color: widget.classicalFooter.bgColor,
            child: SizedBox(
              height: widget.loadIndicatorExtent,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(isReverse),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isReverse) {
    return <Widget>[
      if (!widget.noMore && widget.success)
        Container(
          alignment: Alignment.center,
          child: (widget.loadState == LoadMode.load ||
                      widget.loadState == LoadMode.armed) &&
                  !widget.noMore
              ? Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(
                      widget.classicalFooter.textColor,
                    ),
                  ),
                )
              : widget.loadState == LoadMode.loaded ||
                      widget.loadState == LoadMode.done ||
                      (widget.enableInfiniteLoad &&
                          widget.loadState != LoadMode.loaded) ||
                      widget.noMore
                  ? Icon(
                      _finishedIcon,
                      color: widget.classicalFooter.textColor,
                    )
                  : Transform.rotate(
                      child: Icon(
                        !isReverse ? Icons.arrow_upward : Icons.arrow_downward,
                        color: widget.classicalFooter.textColor,
                      ),
                      angle: 2 * pi * _iconRotationValue,
                    ),
        ),
      SizedBox(height: 6.0),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _showText,
              style: TextStyle(
                fontSize: 16.0,
                color: widget.classicalFooter.textColor,
              ),
            ),
            widget.classicalFooter.showInfo
                ? Container(
                    margin: EdgeInsets.only(
                      top: 2.0,
                    ),
                    child: Text(
                      _infoTextStr,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget.classicalFooter.infoColor,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ];
  }
}
