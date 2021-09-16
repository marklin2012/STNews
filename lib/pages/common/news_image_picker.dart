import 'package:flutter/material.dart';
import 'package:stnews/pages/common/news_action_sheet.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class NewsImagePicker {
  static showPicker({
    required BuildContext context,
    void Function()? galleryTap,
    void Function()? cameraTap,
  }) {
    // 弹窗
    NewsActionSheet.show(
      context: context,
      actions: [
        NewsActionSheetAction(
          onPressed: galleryTap ?? () {},
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '从相册选择图片',
              style: NewsTextStyle.style16NormalBlack,
            ),
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEFF3F9))),
          ),
        ),
        NewsActionSheetAction(
          onPressed: cameraTap ?? () {},
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '拍照',
              style: NewsTextStyle.style16NormalBlack,
            ),
          ),
        ),
        NewsActionSheetAction(
            onPressed: () {
              STRouters.pop(context);
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '取消',
                style: NewsTextStyle.style18BoldBlack,
              ),
            )),
      ],
    );
  }
}
