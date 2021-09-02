import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/notice_model.dart';
import 'package:stnews/utils/st_routers.dart';

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
                      model!.title,
                      style: TextStyle(
                          fontSize: FONTSIZE16, fontWeight: FONTWEIGHT500),
                    ),
                    if (model!.subTitle != null) SizedBox(height: 4),
                    if (model!.subTitle != null)
                      Text(
                        model!.subTitle!,
                        style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: FONTSIZE14,
                            fontWeight: FONTWEIGHT400),
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
                  _getDateTimeString(model!.dateTime),
                  style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: FONTSIZE12,
                      fontWeight: FONTWEIGHT400),
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

  String _getDateTimeString(DateTime time) {
    if (time.isAfter(DateTime.now().add(Duration(minutes: -30)))) {
      return '刚刚';
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -1)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different == 0) {
        return '今天';
      } else {
        return '昨天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -2)))) {
      final different = DateTime.now().difference(time).inDays;
      if (different <= 1) {
        return '昨天';
      }
    }

    if (time.isAfter(DateTime.now().add(Duration(days: -365)))) {
      final month = time.month;
      final day = time.day;
      return '$month-$day';
    }
    final year = time.year;
    final month = time.month;
    final day = time.day;
    return '$year-$month-$day';
  }
}
