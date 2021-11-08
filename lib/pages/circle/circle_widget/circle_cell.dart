import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
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
    this.circleTap,
    this.thumbupedTap,
  }) : super(key: key);

  final MomentModel? circleModel;
  final Function(String? authorID)? authorTap;
  final Function(bool? isThumbuped)? thumbupedTap;
  final Function(MomentModel? circleModel)? circleTap;

  @override
  Widget build(BuildContext context) {
    if (circleModel == null) return Container();
    return InkWell(
      highlightColor: ColorConfig.fourGrey,
      onTap: () {
        if (circleTap != null) {
          circleTap!(circleModel);
        }
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: NewsScale.sw(181, context),
      // height: NewsScale.sh(332, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: EdgeInsets.fromLTRB(
              NewsScale.sw(8, context),
              NewsScale.sh(8, context),
              NewsScale.sw(8, context),
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
          child: circleModel?.images != null
              ? CachedNetworkImage(
                  width: NewsScale.sw(181, context),
                  height: NewsScale.sh(240, context),
                  imageUrl:
                      STString.addPrefixHttp(circleModel?.images?.first) ?? '',
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
              if (authorTap != null) {
                authorTap!(circleModel?.user?.id);
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              alignment: Alignment.centerLeft,
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
            if (thumbupedTap != null) {
              thumbupedTap!(circleModel?.isThumbUp ?? false);
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: NewsScale.sw(67, context),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleModel?.isThumbUp ?? false
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
                  (circleModel?.thumbUpCount ?? 0).toString(),
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
