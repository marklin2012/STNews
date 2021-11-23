import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/moment_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/pages/common/news_photo_view.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/string+.dart';

const PersonHomeCirclesDebounceJumpKey = 'PersonHomeCirclesDebounceJumpKey';
const PersonHomeCirclesDebounceFavouriteKey =
    'PersonHomeCirclesDebounceFavouriteKey';
const PersonHomeCirclesDebounceThumbupKey =
    'PersonHomeCirclesDebounceThumbupKey';
const PersonHomeCirclesDebounceImageKey = 'PersonHomeCirclesDebounceImageKey';

class PersonHomeCircles extends StatelessWidget {
  const PersonHomeCircles({
    Key? key,
    this.userModel,
    this.moments,
    this.thumbupTap,
    this.favourtieTap,
    this.jumpCommentTap,
    this.jumpMomentTap,
  }) : super(key: key);

  final UserModel? userModel;

  final List<MomentModel>? moments;

  final Function(MomentModel, bool)? thumbupTap;

  final Function(MomentModel, bool)? favourtieTap;

  final Function(MomentModel)? jumpCommentTap;

  final Function(MomentModel)? jumpMomentTap;

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
            jumpMomentTap: (MomentModel model) {
              if (jumpMomentTap != null) {
                jumpMomentTap!(model);
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
    this.jumpMomentTap,
  }) : super(key: key);

  final UserModel? userModel;

  final MomentModel? model;

  final Function(MomentModel, bool)? thumbupTap;

  final Function(MomentModel, bool)? favourtieTap;

  final Function(MomentModel)? jumpCommentTap;

  final Function(MomentModel)? jumpMomentTap;

  @override
  Widget build(BuildContext context) {
    if (userModel == null || model == null) return Container();
    return InkWell(
      highlightColor: ColorConfig.fourGrey,
      onTap: () {
        if (jumpMomentTap != null) {
          jumpMomentTap!(model!);
        }
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像名称时间
          _buildUserInfo(),
          Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 12.0),
            child: Text(
              model?.title ?? '',
              style: NewsTextStyle.style18BoldBlack,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              model?.content ?? '',
              style: NewsTextStyle.style16NormalBlack,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
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
        ClipOval(
          clipBehavior: Clip.hardEdge,
          child: NewsImage.networkImage(
            path: userModel?.avatar,
            width: 36,
            height: 36,
            defaultChild: NewsImage.defaultAvatar(),
          ),
        ),
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
    if (model?.images == null || model!.images!.isEmpty) {
      return SizedBox();
    } else if (model!.images!.length == 1) {
      final _galleryItem = STString.addPrefixHttp(model!.images!.first) ?? '';
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              STDebounce().start(
                key: PersonHomeCirclesDebounceImageKey,
                func: () {
                  STRouters.push(
                      context, NewsPhotoView(galleryItems: [_galleryItem]));
                },
                time: 200,
              );
            },
            child: Hero(
              tag: NewsHeroTags.showPhotoImageTag + _galleryItem,
              child: NewsImage.networkImage(
                path: (model?.images != null && model!.images!.length != 0)
                    ? model!.images!.first
                    : null,
                height: 168,
                defaultChild: NewsImage.defaultCircle(),
              ),
            ),
          ),
        ],
      );
    } else {
      List<Widget> _widgets = [];
      List<String> _galleryItems = [];
      for (var i = 0; i < model!.images!.length; i++) {
        final _url = model!.images![i];
        _galleryItems.add(STString.addPrefixHttp(_url) ?? '');
      }
      for (var i = 0; i < model!.images!.length; i++) {
        final _url = model!.images![i];
        final _heroTag = STString.addPrefixHttp(_url) ?? '';
        _widgets.add(
          GestureDetector(
            onTap: () {
              STDebounce().start(
                key: PersonHomeCirclesDebounceImageKey,
                func: () {
                  STRouters.push(
                    context,
                    NewsPhotoView(
                      galleryItems: _galleryItems,
                      defaultImage: i,
                    ),
                  );
                },
                time: 200,
              );
            },
            child: Hero(
              tag: NewsHeroTags.showPhotoImageTag + _heroTag,
              child: NewsImage.networkImage(
                path: _url,
                width: NewsScale.sw(112, context),
                height: NewsScale.sw(112, context),
                defaultChild: NewsImage.defaultCircle(height: 50),
              ),
            ),
          ),
        );
      }
      return Wrap(
        runSpacing: NewsScale.sh(3, context),
        spacing: NewsScale.sw(3, context),
        children: _widgets,
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
            text: (model?.commentCount ?? 0).toString(),
            textStyle: NewsTextStyle.style14NormalSecGrey,
            onTap: _jumpAction,
          ),
          SizedBox(width: 16),
          STButton.icon(
            backgroundColor: Colors.transparent,
            size: STButtonSize.small,
            padding: EdgeInsets.all(4),
            icon: model?.isFavourite ?? false
                ? Image(
                    width: 24,
                    height: 24,
                    image: AssetImage('assets/images/favourited.png'),
                  )
                : Icon(
                    STIcons.commonly_star,
                    color: ColorConfig.textSecColor,
                  ),
            onTap: _favouritedAction,
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
            onTap: _thumbupAction,
          ),
        ],
      ),
    );
  }

  void _jumpAction() {
    if (jumpCommentTap == null) return;
    STDebounce().start(
      key: PersonHomeCirclesDebounceJumpKey,
      func: () {
        jumpCommentTap!(model!);
      },
    );
  }

  void _favouritedAction() {
    if (favourtieTap == null) return;
    STDebounce().start(
      key: PersonHomeCirclesDebounceFavouriteKey,
      func: () {
        favourtieTap!(model!, model?.isFavourite ?? false);
      },
    );
  }

  void _thumbupAction() {
    if (thumbupTap == null) return;
    STDebounce().start(
      key: PersonHomeCirclesDebounceThumbupKey,
      func: () {
        thumbupTap!(model!, model?.isThumbUp ?? false);
      },
    );
  }
}
