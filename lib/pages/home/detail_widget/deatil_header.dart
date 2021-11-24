import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class PostDetailHeaderData {
  String? publishedDate;
  String? title;
  String? authorAvatar;
  String? authorNickName;
  String? authorId;
  bool? isFavedUser;

  PostDetailHeaderData({
    this.publishedDate,
    this.title,
    this.authorAvatar,
    this.authorNickName,
    this.authorId,
    this.isFavedUser,
  });

  PostDetailHeaderData setFavedUser(bool isFaved) {
    return PostDetailHeaderData(
      publishedDate: this.publishedDate,
      title: this.title,
      authorAvatar: this.authorAvatar,
      authorNickName: this.authorNickName,
      authorId: this.authorId,
      isFavedUser: isFaved,
    );
  }
}

const double detailHeaderHeight = 186;

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    Key? key,
    this.authorTap,
    this.onFavouritedUser,
    required this.offset,
    required this.data,
  }) : super(key: key);
  final double offset;
  final Function()? authorTap;
  final Function(bool)? onFavouritedUser;

  final PostDetailHeaderData data;

  @override
  Widget build(BuildContext context) {
    String _publishedDate = '';
    if (data.publishedDate != null) {
      DateTime _temp =
          STString.dateTimeFromString(dateStr: data.publishedDate!);
      _publishedDate = STString.getDateString(_temp);
    }
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: offset / detailHeaderHeight * 80),
                    child: Opacity(
                      opacity: _calculateTitleOpacity(),
                      child: Text(
                        data.title ?? '',
                        style: NewsTextStyle.style28BoldBlack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: offset / detailHeaderHeight * 32,
                              height: 44,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          STButton.icon(
                            padding: EdgeInsets.zero,
                            icon: ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: NewsImage.networkImage(
                                path: data.authorAvatar,
                                width: 36,
                                height: 36,
                                defaultChild: NewsImage.defaultAvatar(),
                              ),
                            ),
                            onTap: () {
                              if (authorTap != null) {
                                authorTap!();
                              }
                            },
                          ),
                          SizedBox(width: 8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.authorNickName ?? '',
                                style: NewsTextStyle.style14NormalBlack,
                              ),
                              if (offset < 125)
                                Opacity(
                                  opacity: 1 - offset / detailHeaderHeight,
                                  child: Text(
                                    _publishedDate,
                                    style: NewsTextStyle.style12NormalThrGrey,
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                      if (data.authorId != null &&
                          data.authorId! != UserProvider.shared.user.id)
                        STButton(
                          type: STButtonType.outline,
                          height: 30,
                          padding: EdgeInsets.fromLTRB(16, 3, 16, 3),
                          text: (data.isFavedUser ?? false) ? '已关注' : '关注',
                          textStyle: NewsTextStyle.style14NormalFirBlue,
                          onTap: () {
                            if (onFavouritedUser != null) {
                              onFavouritedUser!(data.isFavedUser ?? false);
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTitleOpacity() {
    if (offset < detailHeaderHeight / 2) {
      return 1 - offset / detailHeaderHeight * 2;
    } else {
      return 0;
    }
  }
}
