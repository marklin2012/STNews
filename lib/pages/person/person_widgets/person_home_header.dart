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

class PersonHomeHeader extends StatefulWidget {
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
  _PersonHomeHeaderState createState() => _PersonHomeHeaderState();
}

class _PersonHomeHeaderState extends State<PersonHomeHeader> {
  ValueNotifier<bool> _loadingNoti = ValueNotifier(false);
  bool _lastFav = false;

  @override
  void initState() {
    super.initState();
    _lastFav = widget.isFavouritedUser ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_lastFav != widget.isFavouritedUser) {
      _loadingNoti.value = false;
      _lastFav = widget.isFavouritedUser ?? false;
    }
    return Container(
      color: ColorConfig.backgroundColor,
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
            top: 44 - (widget.offset / PersonHomeHeaderHeight * 44),
            child: Container(
              height: 84 - (widget.offset / PersonHomeHeaderHeight * 40),
              child: Row(
                children: [
                  SizedBox(
                    width: widget.offset / PersonHomeHeaderHeight * 32,
                    height: 44,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 12.0),
                    child: NewsAvatarWidget(
                      size: 60 - (widget.offset / PersonHomeHeaderHeight * 24),
                      child: STCaCheImage.loadingImage(
                          imageUrl: widget.user?.avatar),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.user?.nickname ?? '',
                      style: NewsTextStyle.style18BoldBlack,
                    ),
                  ),
                  widget.isSelf ?? true
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: ValueListenableBuilder(
                              valueListenable: _loadingNoti,
                              builder: (context, bool loading, _) {
                                return STButton(
                                  type: STButtonType.outline,
                                  height: 30,
                                  loading: loading,
                                  loadingIconSize: 15,
                                  padding: EdgeInsets.fromLTRB(16, 3, 16, 3),
                                  text: (widget.isFavouritedUser ?? false)
                                      ? '已关注'
                                      : '关注',
                                  textStyle: (widget.isFavouritedUser ?? false)
                                      ? NewsTextStyle.style14NormalThrGrey
                                      : NewsTextStyle.style14NormalFirBlue,
                                  borderColor: (widget.isFavouritedUser ??
                                          false || !loading)
                                      ? ColorConfig.textThrColor
                                      : ColorConfig.baseFirBule,
                                  onTap: () {
                                    _loadingNoti.value = true;
                                    if (widget.favouritedTap != null) {
                                      widget.favouritedTap!(
                                          widget.isFavouritedUser ?? false);
                                    }
                                  },
                                );
                              }),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _claculateBottomHeight(),
            child: Opacity(
              opacity: _claculateBottomOpacity(),
              child: Container(
                color: ColorConfig.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NewsIconTextWidget(
                      icon: Icon(STIcons.label_star),
                      title: (widget.followerCount ?? 0).toString(),
                      unit: '关注',
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: ColorConfig.thrGrey,
                    ),
                    NewsIconTextWidget(
                      icon: Icon(STIcons.label_heart_outline),
                      title: (widget.fansCount ?? 0).toString(),
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
              child: Container(
                width: widget.offset / PersonHomeHeaderHeight * 44,
                height: 44,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  double _claculateBottomHeight() {
    if (widget.offset < 60) {
      return 44 - widget.offset / PersonHomeHeaderHeight * 44;
    }
    return 0;
  }

  double _claculateBottomOpacity() {
    if (widget.offset < 60) {
      return 1 - widget.offset / 60;
    }
    return 0;
  }
}
