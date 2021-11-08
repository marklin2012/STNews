import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';

class PersonHomeHeader extends StatelessWidget {
  const PersonHomeHeader({
    Key? key,
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

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            ListTile(
              leading: NewsAvatarWidget(
                size: 60,
                child: STCaCheImage.loadingImage(imageUrl: user?.avatar),
              ),
              title: Text(
                user?.nickname ?? '',
                style: NewsTextStyle.style18BoldBlack,
              ),
              trailing: isSelf ?? false
                  ? null
                  : STButton(
                      text: (isFavouritedUser ?? false) ? '已关注' : '关注',
                      type: STButtonType.outline,
                      size: STButtonSize.small,
                      onTap: () {
                        if (favouritedTap != null) {
                          favouritedTap!(isFavouritedUser ?? false);
                        }
                      },
                    ),
            ),
            Container(
              color: ColorConfig.backgroundColor,
              margin: EdgeInsets.symmetric(vertical: 12.0),
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
            )
          ],
        ),
      ),
    );
  }
}
