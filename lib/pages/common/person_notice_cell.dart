import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/notice_model.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class PersonNoticeCell extends StatelessWidget {
  const PersonNoticeCell({Key? key, this.model, this.onTap}) : super(key: key);

  final NoticeModel? model;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Container(
        height: 74,
        color: Theme.of(context).backgroundColor,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        height: 74,
        color: Theme.of(context).backgroundColor,
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
                    color: Colors.blue,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model!.title ?? '',
                      style: NewsTextStyle.style16BoldBlack,
                    ),
                    if (model!.subtitle != null) SizedBox(height: 4),
                    if (model!.subtitle != null)
                      Text(
                        model!.subtitle!,
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
                  STString.getDateString(model!.datetime),
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
                if (model!.notices != null && model!.notices! > 0)
                  SizedBox(height: 10),
                if (model!.notices != null && model!.notices! > 0)
                  STBadge(
                    value: model!.notices!.toString(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
