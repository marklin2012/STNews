import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

const double detailHeaderHeight = 186;

class DetailHeader extends StatelessWidget {
  const DetailHeader(
      {Key? key, this.authorTap, this.onFavouritedUser, required this.offset})
      : super(key: key);
  final double offset;
  final Function()? authorTap;
  final Function()? onFavouritedUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(builder: (context, postDetP, _) {
      String _publishedDate = '';
      if (postDetP.postModel.publisheddate != null) {
        DateTime _temp = STString.dateTimeFromString(
            dateStr: postDetP.postModel.publisheddate!);
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
                // color: Colors.white,
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
              bottom: 4,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 1 - offset / detailHeaderHeight,
                      child: Text(
                        postDetP.postModel.title ?? '',
                        style: NewsTextStyle.style28BoldBlack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                              icon: postDetP.postModel.author?.avatar != null
                                  ? ClipOval(
                                      clipBehavior: Clip.hardEdge,
                                      child: CachedNetworkImage(
                                        width: 36,
                                        height: 36,
                                        imageUrl:
                                            postDetP.postModel.author?.avatar ??
                                                "",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            NewsImage.defaultAvatar(),
                                      ),
                                    )
                                  : NewsImage.defaultAvatar(),
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
                                  postDetP.postModel.author?.nickname ?? '',
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
                        if (postDetP.postModel.author?.id != null &&
                            postDetP.postModel.author?.id! !=
                                UserProvider.shared.user.id)
                          STButton(
                            type: STButtonType.outline,
                            height: 30,
                            text: postDetP.isFavouritedUser ? '已关注' : '关注',
                            textStyle: NewsTextStyle.style14NormalFirBlue,
                            onTap: () {
                              if (onFavouritedUser != null) {
                                onFavouritedUser!();
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
    });
  }
}
