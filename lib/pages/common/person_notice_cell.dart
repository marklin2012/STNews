import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/notice_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class PersonNoticeCell extends StatelessWidget {
  const PersonNoticeCell({Key? key, required this.model, this.onTap})
      : super(key: key);

  final NoticeModel model;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        height: 74,
        color: ColorConfig.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.image,
                    size: 36,
                    color: ColorConfig.baseSecBule,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.announceID?.title ?? '',
                      style: NewsTextStyle.style16BoldBlack,
                    ),
                    if (model.announceID?.subscript != null &&
                        model.announceID!.subscript!.length > 0)
                      SizedBox(height: 4),
                    if (model.announceID?.subscript != null &&
                        model.announceID!.subscript!.length > 0)
                      Text(
                        model.announceID!.subscript!,
                        style: NewsTextStyle.style14NormalSecGrey,
                      ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  STString.dateTimeStrFromString(dateStr: model.updatedAt),
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
                if (model.isRead != null && !model.isRead!)
                  SizedBox(height: 10),
                if (model.isRead != null && !model.isRead!) STBadge(dot: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
