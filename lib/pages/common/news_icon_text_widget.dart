import 'package:flutter/material.dart';
import 'package:stnews/utils/news_text_style.dart';

class NewsIconTextWidget extends StatelessWidget {
  const NewsIconTextWidget({
    Key? key,
    this.icon,
    this.title,
    this.unit,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final String? title;
  final String? unit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 24),
          SizedBox(width: 8.0),
          if (title != null)
            Text(
              title ?? '',
              style: NewsTextStyle.style16BoldBlack,
            ),
          if (unit != null)
            Text(
              unit ?? '',
              style: NewsTextStyle.style14NormalBlack,
            ),
        ],
      ),
    );
  }
}
