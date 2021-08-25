import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

/// data 固定格式
/// icon 是图标 如果为空即没有图标
/// title 主要内容
/// 以下只能任选一个
/// isSubTitle 尾部内容
/// isDot 如果不为空即有圆点
/// isHead 如果不为空即有头像

class PersonTile extends StatelessWidget {
  const PersonTile({Key? key, this.onTap, required this.data, this.height = 48})
      : super(key: key);

  final Map data;
  final void Function()? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    bool hasTril = false;
    final hasDot = data['isDot'];
    final hasHead = data['isHead'];
    final hasSubTitle = data['isSubTitle'];
    var subWidget;
    if (hasDot != null || hasHead != null || hasSubTitle != null) {
      hasTril = true;
    }
    if (hasDot != null) {
      subWidget = STBadge(dot: true);
    } else if (hasHead != null) {
      subWidget = Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor,
        ),
      );
    } else if (hasSubTitle != null) {
      subWidget = Text(hasSubTitle,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300));
    }

    final iconData = data['icon'];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Theme.of(context).backgroundColor,
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
                    ),
                  if (iconData != null) SizedBox(width: 14),
                  Text(
                    data['title'],
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ),
                ]),
            Row(children: [
              if (hasTril) subWidget,
              if (hasTril) SizedBox(width: 14),
              Icon(
                STIcons.direction_rightoutlined,
                size: 12,
              )
            ]),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
