import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/circle_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/string+.dart';

enum circleFileType {
  circleFileImage,
  circleFileVideo,
  circleFileOther,
}

class CircleCell extends StatelessWidget {
  const CircleCell({
    Key? key,
    this.circleModel,
    this.authorTap,
    this.isMargin = false,
  }) : super(key: key);

  final CircleModel? circleModel;
  final Function()? authorTap;
  final bool isMargin;

  @override
  Widget build(BuildContext context) {
    if (circleModel == null) return Container();
    return Container(
      width: NewsScale.sw(181, context),
      height: NewsScale.sh(332, context),
      child: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding: EdgeInsets.fromLTRB(
              NewsScale.sh(8, context),
              NewsScale.sh(8, context),
              NewsScale.sh(8, context),
              NewsScale.sh(4, context),
            ),
            child: Text(
              circleModel?.title ?? '',
              style: NewsTextStyle.style14NormalBlack,
              maxLines: 2,
            ),
          ),
          Container(
            height: NewsScale.sh(40, context),
            alignment: Alignment.center,
            child: _buildFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: NewsScale.sw(181, context),
          height: NewsScale.sh(240, context),
          decoration: BoxDecoration(
            color: ColorConfig.baseThrBlue,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: circleModel?.coverImage != null
              ? CachedNetworkImage(
                  width: NewsScale.sw(181, context),
                  height: NewsScale.sh(240, context),
                  imageUrl:
                      STString.addPrefixHttp(circleModel?.coverImage) ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: NewsImage.defaultCircle(),
                  ),
                )
              : Center(
                  child: NewsImage.defaultCircle(),
                ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // 作者详情
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              alignment: Alignment.centerLeft,
              // color: Colors.red,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: NewsScale.sh(8, context),
                        right: NewsScale.sh(4, context)),
                    child: circleModel?.user?.avatar != null
                        ? ClipOval(
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              width: 20,
                              height: 20,
                              imageUrl: STString.addPrefixHttp(
                                      circleModel?.user?.avatar) ??
                                  '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  NewsImage.defaultAvatar(height: 20),
                            ),
                          )
                        : NewsImage.defaultAvatar(height: 20),
                  ),
                  Text(
                    circleModel?.user?.nickname ?? '',
                    style: NewsTextStyle.style12NormalSecGrey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 点赞
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: NewsScale.sw(67, context),
            alignment: Alignment.center,
            // color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleModel?.isUserFavourite ?? false
                    ? Image(
                        width: 18,
                        height: 18,
                        image: AssetImage('assets/images/liked.png'),
                      )
                    : Icon(
                        STIcons.commonly_like,
                        size: 18,
                      ),
                SizedBox(width: NewsScale.sw(5.5, context)),
                Text(
                  (circleModel?.favouriteCount ?? 0).toString(),
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
