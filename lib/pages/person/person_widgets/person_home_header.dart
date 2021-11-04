import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';

class PersonHomeHeader extends StatefulWidget {
  const PersonHomeHeader({Key? key, required this.userID}) : super(key: key);
  final String userID;
  @override
  _PersonHomeHeaderState createState() => _PersonHomeHeaderState();
}

class _PersonHomeHeaderState extends State<PersonHomeHeader> {
  UserHomeProvider get userHomeProvider =>
      Provider.of<UserHomeProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserHomeProvider>(builder: (context, userHomeP, _) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              ListTile(
                leading: NewsAvatarWidget(
                  size: 60,
                  child: STCaCheImage.loadingImage(
                      imageUrl: userHomeP.infoModel.user?.avatar),
                ),
                title: Text(
                  userHomeP.infoModel.user?.nickname ?? '',
                  style: NewsTextStyle.style18BoldBlack,
                ),
                trailing: userHomeP.isSelf
                    ? null
                    : STButton(
                        text: userHomeP.isFavouritedUser ? '已关注' : '关注',
                        type: STButtonType.outline,
                        size: STButtonSize.small,
                        onTap: _changeFavouriteStatus,
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
                      icon: Icons.favorite,
                      title:
                          (userHomeP.infoModel.followerCount ?? 0).toString(),
                      unit: '关注',
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: ColorConfig.thrGrey,
                    ),
                    NewsIconTextWidget(
                      icon: Icons.favorite_outline,
                      title: (userHomeP.infoModel.fansCount ?? 0).toString(),
                      unit: '粉丝',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _changeFavouriteStatus() async {
    NewsLoading.start(context);
    await userHomeProvider.changeFavouritedUserStatus();
    NewsLoading.stop();
  }
}
