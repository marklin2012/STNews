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

const CircleCellDebounceAuthorKey = 'CircleCellDebounceAuthorKey';
const CircleCellDebounceThunbupKey = 'CircleCellDebounceThunbupKey';

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
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: InkWell(
        highlightColor: ColorConfig.fourGrey,
        onTap: () {
          if (circleTap != null) {
            circleTap!(circleModel);
          }
        },
        child: Card(
          elevation: 0,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          ),
          child: NewsImage.networkImage(
            path: (circleModel?.images != null &&
                    circleModel!.images!.length != 0)
                ? circleModel?.images?.first
                : null,
            width: NewsScale.sw(181, context),
            height: NewsScale.sh(240, context),
            defaultChild: NewsImage.defaultCircle(),
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
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
            onTap: _authorAction,
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
                    child: ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: NewsImage.networkImage(
                        path: circleModel?.user?.avatar,
                        width: 20,
                        height: 20,
                        defaultChild: NewsImage.defaultAvatar(height: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      STString.limitStringLength(circleModel?.user?.nickname),
                      style: NewsTextStyle.style12NormalSecGrey,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _thumbupAction,
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: NewsScale.sw(67, context),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleModel?.isThumbUp ?? false
                    ? Icon(
                        STIcons.label_like,
                        size: 18,
                        color: ColorConfig.redColor,
                      )
                    : Icon(
                        STIcons.label_like_outline,
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

  void _authorAction() {
    if (authorTap == null) return;
    STDebounce().start(
      key: CircleCellDebounceAuthorKey,
      func: () {
        // 作者详情
        authorTap!(circleModel?.user?.id);
      },
    );
  }

  void _thumbupAction() {
    if (thumbupedTap == null) return;
    STDebounce().start(
      key: CircleCellDebounceThunbupKey,
      func: () {
        // 点赞
        thumbupedTap!(circleModel?.isThumbUp ?? false);
      },
    );
  }
}
