import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_comment_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/string+.dart';

class CircleCommentCell extends StatelessWidget {
  const CircleCommentCell({
    Key? key,
    this.model,
    this.replayTap,
    this.commentThumbupTap,
  }) : super(key: key);

  final MomentCommentModel? model;

  final Function(MomentCommentModel)? replayTap;

  final Function(String, bool)? commentThumbupTap;

  @override
  Widget build(BuildContext context) {
    if (model == null) return Container();
    return Column(
      children: _buildComment(context),
    );
  }

  List<Widget> _buildComment(BuildContext context) {
    List<Widget> _listWidgets = [];
    Widget commentW = GestureDetector(
      onLongPress: () {
        if (replayTap != null) {
          replayTap!(model!);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(top: 16.0, bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsAvatarWidget(
              child: STCaCheImage.loadingImage(
                  imageUrl: model?.user?.avatar ?? ''),
            ),
            SizedBox(width: 8.0),
            Expanded(child: _buildCenter(model!, isReplayed: false)),
            SizedBox(width: 8.0),
            _buildTriling(model!),
          ],
        ),
      ),
    );
    _listWidgets.add(commentW);
    if (model?.references != null && model!.references!.isNotEmpty) {
      model!.references!.forEach((replayed) {
        Widget replayedW = GestureDetector(
          onLongPress: () {
            if (replayTap != null) {
              replayTap!(replayed);
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 56, right: 16),
            padding: EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsAvatarWidget(
                  child: STCaCheImage.loadingImage(
                      imageUrl: replayed.user?.avatar ?? ''),
                ),
                SizedBox(width: 8.0),
                Expanded(child: _buildCenter(replayed)),
                SizedBox(width: 8.0),
                _buildTriling(replayed),
              ],
            ),
          ),
        );
        _listWidgets.add(replayedW);
      });
    }
    _listWidgets.add(_buildLines(context));
    return _listWidgets;
  }

  Widget _buildCenter(MomentCommentModel commentModel,
      {bool isReplayed = true}) {
    String _publishDateStr = '昨天';
    if (commentModel.publisheddate != null) {
      DateTime datetime =
          STString.dateTimeFromString(dateStr: commentModel.publisheddate!);
      _publishDateStr = STString.getDateString(datetime);
    }
    bool isAuthorReplayed = false;
    if (isReplayed && commentModel.moment?.user?.id == commentModel.user?.id) {
      isAuthorReplayed = true;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                commentModel.user?.nickname ?? '用户昵称',
                style: NewsTextStyle.style12NormalSecGrey,
              ),
              if (isReplayed && isAuthorReplayed) _buildAuthorTag(),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isReplayed && !isAuthorReplayed)
                Text(
                  '回复',
                  style: NewsTextStyle.style14NormalBlack,
                ),
              if (isReplayed && !isAuthorReplayed)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    commentModel.moment?.user?.nickname ?? '作者昵称',
                    style: NewsTextStyle.style12NormalSecGrey,
                  ),
                ),
              Container(
                // color: Colors.yellow,
                child: Text(
                  commentModel.content ?? '',
                  style: NewsTextStyle.style14NormalBlack,
                ),
              ),
              SizedBox(width: 8.0),
              Container(
                // color: Colors.red,
                child: Text(
                  _publishDateStr,
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriling(MomentCommentModel commentModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点赞圈子的评论
        if (commentThumbupTap != null) {
          commentThumbupTap!(
              commentModel.id!, commentModel.isUserFavourite ?? false);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            (commentModel.favouriteCount ?? 0).toString(),
            style: NewsTextStyle.style12NormalThrGrey,
          ),
          SizedBox(width: 5.4),
          commentModel.isUserFavourite ?? false
              ? Image(
                  width: 18,
                  height: 18,
                  image: AssetImage('assets/images/liked.png'),
                )
              : Icon(
                  STIcons.commonly_like,
                  size: 18,
                ),
        ],
      ),
    );
  }

  Widget _buildLines(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 56.0),
      child: Container(
        width: NewsScale.screenW(context) - 56.0,
        height: 1,
        color: ColorConfig.fourGrey,
      ),
    );
  }

  Widget _buildAuthorTag() {
    return Container(
      margin: EdgeInsets.only(left: 8),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: ColorConfig.baseFourBlue,
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Text(
        '作者',
        style: NewsTextStyle.style12NormalSecBlue,
      ),
    );
  }
}
