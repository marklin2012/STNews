import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/utils/news_text_style.dart';

class CircleDetailContent extends StatelessWidget {
  const CircleDetailContent({
    Key? key,
    this.images,
    this.title,
    this.content,
    this.commentCount,
  }) : super(key: key);

  final List<String>? images;

  final String? title;

  final String? content;

  final int? commentCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PageViewWidget(
          isAutoRoll: false,
          isLooped: false,
          pageList: images,
          margin: EdgeInsets.zero,
          height: 430,
          decoration: BoxDecoration(
            color: ColorConfig.baseFourBlue,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 16, 12, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: NewsTextStyle.style18BoldBlack,
                maxLines: 2,
              ),
              SizedBox(height: 8.0),
              Text(
                content ?? '',
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
                  commentCount != null ? '评论（$commentCount）' : '评论',
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
