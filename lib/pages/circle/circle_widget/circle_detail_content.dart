import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/utils/news_text_style.dart';

class CircleDetailContent extends StatelessWidget {
  const CircleDetailContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PageViewWidget(
          isAutoRoll: false,
          pageList: [''],
          margin: EdgeInsets.zero,
          height: 430,
          decoration: BoxDecoration(
            color: ColorConfig.baseFourBlue,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '这是一条标题',
                style: NewsTextStyle.style18BoldBlack,
              ),
              SizedBox(height: 8.0),
              Text(
                '正文描述正文描述正文描述正文描述正文描述正文描述正文描述正文描述正文描述！',
                style: NewsTextStyle.style16NormalBlack,
              ),
              SizedBox(height: 12.0),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: ColorConfig.thrGrey,
                    ),
                  ),
                ),
                child: Text(
                  '评论（132）',
                  style: NewsTextStyle.style16NormalBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
