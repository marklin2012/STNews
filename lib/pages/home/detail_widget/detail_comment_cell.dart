import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/comment_model.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/string+.dart';

class CommentCell extends StatelessWidget {
  const CommentCell({Key? key, this.model}) : super(key: key);

  final CommentModel? model;

  @override
  Widget build(BuildContext context) {
    late String _publishDateStr;
    if (model?.pubishtime != null) {
      _publishDateStr = STString.getDateString(model!.pubishtime!);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  STCaCheImage.loadingImage(imageUrl: model?.user?.avatar),
                  SizedBox(width: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model?.user?.nickname ?? '用户昵称',
                        style: NewsTextStyle.style14NormalBlack,
                      ),
                      Text(
                        _publishDateStr,
                        style: NewsTextStyle.style12NormalThrGrey,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model?.favourites ?? '',
                    style: NewsTextStyle.style12NormalThrGrey,
                  ),
                  SizedBox(width: 5.4),
                  STButton.icon(
                    backgroundColor: Colors.transparent,
                    icon: Icon(
                      STIcons.commonly_like,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    onTap: () {
                      // TODO 点赞某一条评论
                    },
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(64, 12, 24, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              model?.content ?? '',
              style: NewsTextStyle.style14NormalBlack,
            ),
          ),
        ],
      ),
    );
  }
}
