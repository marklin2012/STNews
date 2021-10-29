import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';

/// data 固定格式
/// icon 是图标 如果为空即没有图标
/// title 主要内容
/// 以下只能任选一个
/// isSubTitle 尾部内容
/// isDot 如果不为空即有圆点
/// isHead 如果不为空即有头像

class PersonTile extends StatelessWidget {
  const PersonTile({
    Key? key,
    this.onTap,
    required this.data,
    this.height = 48,
    this.iconColor,
    this.titleStyle,
    this.subTitleStyle,
  }) : super(key: key);

  final Map data;
  final void Function()? onTap;
  final double height;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    bool hasTril = false;
    final hasDot = data['isDot'];
    final hasHead = data['isHead'];
    final hasSubTitle = data['isSubTitle'];
    Widget? subWidget;
    if (hasDot != null || hasHead != null || hasSubTitle != null) {
      hasTril = true;
    }
    if (hasDot != null) {
      if (hasDot is bool && hasDot) {
        subWidget = STBadge(dot: true);
      }
    } else if (hasHead != null) {
      final _imagePath = hasHead as String;
      subWidget = NewsAvatarWidget(
        child: STCaCheImage.loadingImage(imageUrl: _imagePath),
      );
    } else if (hasSubTitle != null) {
      subWidget = Text(hasSubTitle,
          style: subTitleStyle ?? NewsTextStyle.style16NormalSecGrey);
    }

    final iconData = data['icon'];
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Ink(
        decoration: BoxDecoration(
          color: ColorConfig.backgroundColor,
        ),
        child: InkWell(
          highlightColor: ColorConfig.accentColor,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (iconData != null)
                        Icon(
                          iconData,
                          size: 20,
                          color: iconColor ?? Colors.black,
                        ),
                      if (iconData != null) SizedBox(width: 14),
                      Text(
                        data['title'],
                        style: titleStyle ?? NewsTextStyle.style16NormalBlack,
                      ),
                    ]),
                Row(children: [
                  if (hasTril && subWidget != null) subWidget,
                  if (hasTril) SizedBox(width: 14),
                  Icon(
                    STIcons.direction_rightoutlined,
                    size: 12,
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
