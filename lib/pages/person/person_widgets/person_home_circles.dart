import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stnews/models/moment_model.dart';

import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/string+.dart';

class PersonHomeCircles extends StatelessWidget {
  const PersonHomeCircles(
      {Key? key,
      this.userModel,
      this.moments,
      this.thumbupTap,
      this.favourtieTap,
      this.jumpCommentTap})
      : super(key: key);

  final UserModel? userModel;

  final List<MomentModel>? moments;

  final Function(MomentModel, bool)? thumbupTap;

  final Function(MomentModel, bool)? favourtieTap;

  final Function(MomentModel)? jumpCommentTap;

  @override
  Widget build(BuildContext context) {
    if (userModel == null || moments == null) {
      return SliverToBoxAdapter();
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          MomentModel? model = moments?[index];
          return PersonHomeCirclesCell(
            userModel: userModel,
            model: model,
            jumpCommentTap: (MomentModel model) {
              if (jumpCommentTap != null) {
                jumpCommentTap!(model);
              }
            },
            favourtieTap: (MomentModel model, bool isFaved) {
              if (favourtieTap != null) {
                favourtieTap!(model, isFaved);
              }
            },
            thumbupTap: (MomentModel model, bool isFaved) {
              if (thumbupTap != null) {
                thumbupTap!(model, isFaved);
              }
            },
          );
        },
        childCount: moments?.length,
      ),
    );
  }
}

class PersonHomeCirclesCell extends StatelessWidget {
  const PersonHomeCirclesCell({
    Key? key,
    this.model,
    this.userModel,
    this.thumbupTap,
    this.favourtieTap,
    this.jumpCommentTap,
  }) : super(key: key);

  final UserModel? userModel;

  final MomentModel? model;

  final Function(MomentModel, bool)? thumbupTap;

  final Function(MomentModel, bool)? favourtieTap;

  final Function(MomentModel)? jumpCommentTap;

  @override
  Widget build(BuildContext context) {
    if (userModel == null || model == null) return Container();
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像名称时间
          _buildUserInfo(),
          SizedBox(height: 16),
          Text(
            model?.title ?? '',
            style: NewsTextStyle.style18BoldBlack,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Text(
            model?.content ?? '',
            style: NewsTextStyle.style16NormalBlack,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // 图片的展示
          _buildImages(context),
          // 底部按钮
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    String _publishedDate = '昨天';
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userModel?.avatar != null
            ? ClipOval(
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  width: 36,
                  height: 36,
                  imageUrl: STString.addPrefixHttp(userModel?.avatar) ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => NewsImage.defaultAvatar(),
                ),
              )
            : NewsImage.defaultAvatar(),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel?.nickname ?? '林老师',
              style: NewsTextStyle.style14NormalBlack,
            ),
            Text(
              _publishedDate,
              style: NewsTextStyle.style12NormalThrGrey,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildImages(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: _buildSubImages(context),
    );
  }

  Widget _buildSubImages(BuildContext context) {
    if (model?.images == null || model!.images!.isEmpty) {
      return Container();
    } else if (model!.images!.length == 1) {
      return Container(
        color: ColorConfig.baseFourBlue,
        height: 168,
        child: CachedNetworkImage(
          height: 168,
          imageUrl: STString.addPrefixHttp(model?.images?.first) ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: NewsImage.defaultCircle(),
          ),
        ),
      );
    } else {
      return Wrap(
        runSpacing: NewsScale.sh(3, context),
        spacing: NewsScale.sw(3, context),
        children: model!.images!.map((e) {
          return Container(
            color: ColorConfig.baseFourBlue,
            width: NewsScale.sw(112, context),
            height: NewsScale.sw(112, context),
            child: CachedNetworkImage(
              imageUrl: STString.addPrefixHttp(e) ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: NewsImage.defaultCircle(height: 50),
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          STButton(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(4.0),
            icon: Icon(
              STIcons.commonly_message,
              color: ColorConfig.textSecColor,
            ),
            text: '12',
            textStyle: NewsTextStyle.style14NormalSecGrey,
            onTap: () {
              if (jumpCommentTap != null) {
                jumpCommentTap!(model!);
              }
            },
          ),
          SizedBox(width: 16),
          STButton.icon(
            backgroundColor: Colors.transparent,
            size: STButtonSize.small,
            padding: EdgeInsets.all(4),
            icon: Icon(
              STIcons.commonly_star,
              color: ColorConfig.textSecColor,
            ),
            onTap: () {
              if (favourtieTap != null) {
                favourtieTap!(model!, false);
              }
            },
          ),
          SizedBox(width: 16),
          NewsIconTextWidget(
            icon: model?.isThumbUp ?? false
                ? Image(
                    width: 24,
                    height: 24,
                    image: AssetImage('assets/images/liked.png'),
                  )
                : Icon(
                    STIcons.commonly_like,
                  ),
            unit: (model?.thumbUpCount ?? 0).toString(),
            onTap: () {
              if (thumbupTap != null) {
                thumbupTap!(model!, false);
              }
            },
          ),
        ],
      ),
    );
  }
}
