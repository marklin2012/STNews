import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/comment_model.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/string+.dart';

class CommentCell extends StatefulWidget {
  const CommentCell({Key? key, this.model}) : super(key: key);

  final CommentModel? model;

  @override
  _CommentCellState createState() => _CommentCellState();
}

class _CommentCellState extends State<CommentCell> {
  late CommentModel? _model;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    late String _publishDateStr;
    if (_model?.publisheddate != null) {
      DateTime datetime =
          STString.dateTimeFromString(dateStr: _model!.publisheddate!);
      _publishDateStr = STString.getDateString(datetime);
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
                  NewsAvatarWidget(
                    child: STCaCheImage.loadingImage(
                        imageUrl: _model?.user?.avatar),
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model?.user?.nickname ?? '用户昵称',
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
                    _model?.favouriteCount.toString() ?? '',
                    style: NewsTextStyle.style12NormalThrGrey,
                  ),
                  SizedBox(width: 5.4),
                  STButton.icon(
                    backgroundColor: Colors.transparent,
                    icon: _model?.isUserFavourite ?? false
                        ? Image(
                            width: 18,
                            height: 18,
                            image: AssetImage('assets/images/liked.png'),
                          )
                        : Icon(
                            STIcons.commonly_like,
                            size: 18,
                          ),
                    padding: EdgeInsets.zero,
                    onTap: _commentFavourite,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(64, 12, 24, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              _model?.content ?? '',
              style: NewsTextStyle.style14NormalBlack,
            ),
          ),
        ],
      ),
    );
  }

  void _commentFavourite() {
    NewsLoading.start(context);
    bool _temp = _model?.isUserFavourite ?? false;
    Api.commentFavourite(comment: _model?.id, status: !_temp).then((result) {
      NewsLoading.stop();
      if (result.success) {
        _model?.isUserFavourite = !_temp;
        setState(() {});
      }
    });
  }
}
