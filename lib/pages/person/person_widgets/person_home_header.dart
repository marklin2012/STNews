import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';

const PersonHomeHeaderHeight = 172.0;

class PersonHomeHeader extends StatelessWidget {
  const PersonHomeHeader({
    Key? key,
    required this.offset,
    this.user,
    this.isSelf,
    this.isFavouritedUser,
    this.followerCount,
    this.fansCount,
    this.favouritedTap,
  }) : super(key: key);

  final UserModel? user;
  final bool? isSelf;
  final bool? isFavouritedUser;
  final int? followerCount;
  final int? fansCount;
  final Function(bool)? favouritedTap;
  final double offset;

  @override
  Widget build(BuildContext context) {
    // debugPrint('$offset');
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 44,
              child: Row(
                children: [
                  IconButton(
                    iconSize: 24,
                    icon: Icon(
                      STIcons.direction_leftoutlined,
                      color: ColorConfig.textFirColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 44 - (offset / PersonHomeHeaderHeight * 44),
            child: Container(
              height: 84 - (offset / PersonHomeHeaderHeight * 40),
              child: Row(
                children: [
                  SizedBox(
                    width: offset / PersonHomeHeaderHeight * 32,
                    height: 44,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 12.0),
                    child: NewsAvatarWidget(
                      size: 60 - (offset / PersonHomeHeaderHeight * 24),
                      child: STCaCheImage.loadingImage(imageUrl: user?.avatar),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      user?.nickname ?? '',
                      style: NewsTextStyle.style18BoldBlack,
                    ),
                  ),
                  isSelf ?? false
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: STButton(
                            height: 30,
                            type: STButtonType.outline,
                            padding: EdgeInsets.fromLTRB(16, 3, 16, 3),
                            text: (isFavouritedUser ?? false) ? '已关注' : '关注',
                            onTap: () {
                              if (favouritedTap != null) {
                                favouritedTap!(isFavouritedUser ?? false);
                              }
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 1 - offset / PersonHomeHeaderHeight,
              child: Container(
                color: ColorConfig.backgroundColor,
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NewsIconTextWidget(
                      icon: Icon(Icons.favorite),
                      title: (followerCount ?? 0).toString(),
                      unit: '关注',
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: ColorConfig.thrGrey,
                    ),
                    NewsIconTextWidget(
                      icon: Icon(Icons.favorite_outline),
                      title: (fansCount ?? 0).toString(),
                      unit: '粉丝',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: 44,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: offset / PersonHomeHeaderHeight * 44,
                height: 44,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 44 - (offset / PersonHomeHeaderHeight * 44),
            right: 16,
            width: 85,
            child: Container(
              height: 84 - (offset / PersonHomeHeaderHeight * 40),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (favouritedTap != null) {
                    favouritedTap!(isFavouritedUser ?? false);
                  }
                },
                child: Center(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
