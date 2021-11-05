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
    this.addHeaderLine,
    this.addFooterLine,
  }) : super(key: key);

  final bool? addHeaderLine;

  final bool? addFooterLine;

  final MomentCommentModel? model;

  final Function(MomentCommentModel)? replayTap;

  final Function(String, bool)? commentThumbupTap;

  bool get isReplayed => model?.reference != null;

  bool get isAuthorReplayed => model?.moment?.user?.id == model?.user;

  @override
  Widget build(BuildContext context) {
    if (model == null) return Container();
    return InkWell(
      highlightColor: ColorConfig.baseFourBlue,
      onLongPress: () {
        if (replayTap != null) {
          replayTap!(model!);
        }
      },
      child: Container(
        child: Column(
          children: [
            if (addHeaderLine != null && addHeaderLine!) _buildLines(context),
            _buildContent(),
            if (addFooterLine != null && addFooterLine!) _buildLines(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    EdgeInsets _margin;
    EdgeInsets _padding;
    if (isReplayed) {
      _margin = EdgeInsets.only(left: 56, right: 16);
      _padding = EdgeInsets.only(bottom: 12.0);
    } else {
      _margin = EdgeInsets.symmetric(horizontal: 16.0);
      _padding = EdgeInsets.only(top: 16.0, bottom: 12.0);
    }
    return Container(
      margin: _margin,
      padding: _padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsAvatarWidget(
            child: STCaCheImage.loadingImage(
                imageUrl: model?.moment?.user?.avatar ?? ''),
          ),
          SizedBox(width: 8.0),
          Expanded(child: _buildCenter()),
          SizedBox(width: 8.0),
          _buildTriling(),
        ],
      ),
    );
  }

  Widget _buildCenter() {
    String _publishDateStr = '昨天';
    if (model?.publisheddate != null) {
      DateTime datetime =
          STString.dateTimeFromString(dateStr: model!.publisheddate!);
      _publishDateStr = STString.getDateString(datetime);
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                model?.moment?.user?.nickname ?? '用户昵称',
                style: NewsTextStyle.style14NormalBlack,
              ),
              if (isReplayed && isAuthorReplayed) _buildAuthorTag(),
            ],
          ),
          Row(
            children: [
              if (isReplayed && !isAuthorReplayed)
                Text(
                  '回复',
                  style: NewsTextStyle.style14NormalBlack,
                ),
              if (isReplayed && !isAuthorReplayed)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(model?.moment?.user?.nickname ?? '作者昵称'),
                ),
              Text(
                model?.content ?? '',
                style: NewsTextStyle.style14NormalBlack,
              ),
              SizedBox(width: 8.0),
              Text(
                _publishDateStr,
                style: NewsTextStyle.style12NormalThrGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriling() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点赞圈子的评论
        if (commentThumbupTap != null) {
          commentThumbupTap!(model!.id!, model?.isUserFavourite ?? false);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            (model?.favouriteCount ?? 0).toString(),
            style: NewsTextStyle.style12NormalThrGrey,
          ),
          SizedBox(width: 5.4),
          model?.isUserFavourite ?? false
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
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      decoration: BoxDecoration(
        color: ColorConfig.baseFirBule,
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Text(
        '作者',
        style: NewsTextStyle.style12NormalSecBlue,
      ),
    );
  }
}
