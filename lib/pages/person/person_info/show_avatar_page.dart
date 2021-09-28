import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_action_sheet.dart';

import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class ShowAvatarPage extends StatelessWidget {
  static const HeroTag = 'avatar_Tag';

  const ShowAvatarPage({Key? key, this.canSave}) : super(key: key);

  /// 是否有保存图片的按钮
  final bool? canSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: ColorConfig.textFirColor,
            ),
          ),
          if (canSave != null && canSave!)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: STButton.icon(
                backgroundColor: Colors.transparent,
                icon: Icon(
                  STIcons.commonly_pointmenu,
                  color: ColorConfig.primaryColor,
                ),
                onTap: () {
                  NewsActionSheet.show(
                    backgroundCoplor: Colors.transparent,
                    context: context,
                    actions: [
                      NewsActionSheetAction(
                        onPressed: () {
                          /// 保存图片
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: ColorConfig.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '保存图片',
                            style: NewsTextStyle.style16NormalBlack,
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      ),
                      NewsActionSheetAction(
                        onPressed: () {
                          STRouters.pop(context);
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: ColorConfig.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '取消',
                            style: NewsTextStyle.style17BoldBlack,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                      ),
                    ],
                  );
                },
              ),
            ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: ColorConfig.baseSecBule,
              child: Hero(
                tag: ShowAvatarPage.HeroTag,
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return STCaCheImage.loadingImage(
                      imageUrl: userProvider.user.avatar,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
