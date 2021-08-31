import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stnews/utils/st_routers.dart';

class NewsActionSheetAction extends StatelessWidget {
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

  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: decoration ?? BoxDecoration(),
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
        child: DefaultTextStyle(
          style: textStyle ??
              TextStyle(
                fontSize: FONTSIZE16,
                fontWeight: FONTWEIGHT400,
                color: CupertinoTheme.of(context).primaryColor,
              ),
          child: child,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class NewsActionSheet extends StatefulWidget {
  const NewsActionSheet(
      {Key? key, this.title, this.message, this.acitons, this.closeable})
      : super(key: key);

  final String? title;

  final String? message;

  final List<Widget>? acitons;

  final bool? closeable;

  static void show({
    required BuildContext context,
    String? title,
    String? message,
    List<Widget>? actions,
    bool closeable = true,
  }) {
    final actionSheet = NewsActionSheet(
      title: title,
      message: message,
      acitons: actions,
      closeable: closeable,
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title != null && widget.title!.isNotEmpty) {
      final _title = Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          widget.title!,
          style: TextStyle(
            fontSize: FONTSIZE18,
            fontWeight: FONTWEIGHT500,
            color: Theme.of(context).accentColor,
          ),
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
          style: TextStyle(
            fontSize: FONTSIZE16,
            fontWeight: FONTWEIGHT400,
            color: Theme.of(context).accentColor,
          ),
        ),
      );
      _lists.add(_message);
    }
    if (widget.acitons != null && widget.acitons!.isNotEmpty) {
      _lists.addAll(widget.acitons!);
    }

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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _lists,
              ),
            ),
          )
        ],
      ),
    );
  }
}
