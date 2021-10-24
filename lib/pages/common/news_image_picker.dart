import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
          decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: ColorConfig.fourGrey, width: 1)),
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
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '取消',
              style: NewsTextStyle.style18BoldBlack,
            ),
          ),
        ),
      ],
    );
  }
}
