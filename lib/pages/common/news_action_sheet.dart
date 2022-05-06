import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

class NewsActionSheetAction extends StatefulWidget {
  static const newsActionSheetDebounceKey = 'NewsActionSheetDebounceKey';
  const NewsActionSheetAction(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.textStyle,
      this.padding,
      this.decoration})
      : super(key: key);

  final VoidCallback onPressed;

  final Widget child;

  final TextStyle? textStyle;

  final EdgeInsets? padding;

  final BoxDecoration? decoration;

  @override
  _NewsActionSheetActionState createState() => _NewsActionSheetActionState();
}

class _NewsActionSheetActionState extends State<NewsActionSheetAction> {
  late Color _originColor;
  late ValueNotifier<Color> _colorNoti;

  @override
  void initState() {
    super.initState();
    _originColor = widget.decoration?.color ?? ColorConfig.primaryColor;
    _colorNoti = ValueNotifier(_originColor);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        STDebounce().start(
          key: NewsActionSheetAction.newsActionSheetDebounceKey,
          func: widget.onPressed,
          time: 200,
        );
      },
      onTapDown: (TapDownDetails tapDownDetails) {
        _colorNoti.value = ColorConfig.fourGrey;
      },
      onTapUp: (TapUpDetails tapUpDetails) {
        _colorNoti.value = _originColor;
      },
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
        _colorNoti.value = _originColor;
      },
      onVerticalDragEnd: (DragEndDetails dragEndDetails) {
        _colorNoti.value = _originColor;
      },
      child: ValueListenableBuilder(
          valueListenable: _colorNoti,
          builder: (buildContext, Color color, _) {
            BoxDecoration decoration = BoxDecoration(
              color: color,
              border: widget.decoration?.border,
              borderRadius: widget.decoration?.borderRadius,
              image: widget.decoration?.image,
              boxShadow: widget.decoration?.boxShadow,
              gradient: widget.decoration?.gradient,
              backgroundBlendMode: widget.decoration?.backgroundBlendMode,
              shape: widget.decoration?.shape ?? BoxShape.rectangle,
            );
            return Container(
              alignment: Alignment.center,
              decoration: decoration,
              padding: widget.padding ?? EdgeInsets.zero,
              child: DefaultTextStyle(
                style: widget.textStyle ?? NewsTextStyle.style16NormalWhite,
                child: widget.child,
                textAlign: TextAlign.center,
              ),
            );
          }),
    );
  }
}

class NewsActionSheet extends StatefulWidget {
  const NewsActionSheet({
    Key? key,
    this.title,
    this.message,
    this.acitons,
    this.closeable,
    this.backgroundColor,
  }) : super(key: key);

  final String? title;

  final String? message;

  final List<Widget>? acitons;

  final bool? closeable;

  final Color? backgroundColor;

  static void show({
    required BuildContext context,
    String? title,
    String? message,
    List<Widget>? actions,
    bool closeable = true,
    Color? backgroundCoplor,
  }) {
    final actionSheet = NewsActionSheet(
      title: title,
      message: message,
      acitons: actions,
      closeable: closeable,
      backgroundColor: backgroundCoplor,
    );
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: closeable,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return actionSheet;
      },
    );
  }

  static void hide(
    BuildContext context,
  ) {
    Navigator.pop(context);
  }

  @override
  _NewsActionSheetState createState() => _NewsActionSheetState();
}

class _NewsActionSheetState extends State<NewsActionSheet> {
  late List<Widget> _lists;

  @override
  void initState() {
    super.initState();
    _lists = [];
    if (widget.title != null && widget.title!.isNotEmpty) {
      final _title = Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          widget.title!,
          style: NewsTextStyle.style18BoldSecBlue,
        ),
      );
      _lists.add(_title);
    }
    if (widget.message != null && widget.message!.isNotEmpty) {
      final _message = Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          widget.message!,
          maxLines: 2,
          style: NewsTextStyle.style16NormalSecBlue,
        ),
      );
      _lists.add(_message);
    }
    if (widget.acitons != null && widget.acitons!.isNotEmpty) {
      _lists.addAll(widget.acitons!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.closeable != null && widget.closeable!) {
                NewsActionSheet.hide(context);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: ColorConfig.primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: _lists,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
