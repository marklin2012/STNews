import 'package:flutter/material.dart';
import 'package:stnews/utils/news_text_style.dart';

class EmptyViewWidget extends StatelessWidget {
  const EmptyViewWidget({
    Key? key,
    this.spaceH = 100,
    this.image,
    this.content,
    this.imageBGSize = 80,
    this.textStyle = NewsTextStyle.style16NormalSecGrey,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  /// 距离头部的高度
  final double? spaceH;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      color: backgroundColor,
      child: Column(
        children: [
          if (spaceH != null) SizedBox(height: spaceH),
          Container(
            width: imageBGSize,
            height: imageBGSize,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: image,
          ),
          if (content != null) SizedBox(height: 24),
          if (content != null)
            Text(
              content!,
              style: textStyle,
            ),
        ],
      ),
    );
  }
}
