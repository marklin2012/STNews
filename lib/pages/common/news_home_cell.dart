import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';

class NewsHomeCell extends StatelessWidget {
  const NewsHomeCell({
    Key? key,
    this.onTap,
    this.title,
    this.subTitle,
    this.trailing,
  }) : super(key: key);

  final Widget? title;

  final Widget? subTitle;

  final Widget? trailing;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: ColorConfig.accentColor,
      onTap: onTap,
      child: Container(
        height: 92,
        margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: title,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: subTitle,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(12, 8, 8, 8),
              height: 76,
              width: 102,
              decoration: BoxDecoration(
                color: ColorConfig.accentColor,
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              child: trailing,
            ),
          ],
        ),
      ),
    );
  }
}
