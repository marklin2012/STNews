import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:stnews/utils/string+.dart';

class PersonHomeCircles extends StatefulWidget {
  const PersonHomeCircles({Key? key}) : super(key: key);

  @override
  _PersonHomeCirclesState createState() => _PersonHomeCirclesState();
}

class _PersonHomeCirclesState extends State<PersonHomeCircles> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserHomeProvider>(
        builder: (BuildContext context, UserHomeProvider userHomeP, _) {
      // if (userHomeP.infoModel.post == null ||
      //     (userHomeP.infoModel.post != null &&
      //         userHomeP.infoModel.post!.isEmpty))
      //   return SliverToBoxAdapter(
      //     child: Container(
      //       height: MediaQuery.of(context).size.height -
      //           MediaQuery.of(context).padding.top -
      //           MediaQuery.of(context).padding.bottom -
      //           210,
      //       child: EmptyViewWidget(
      //         content: '暂无发布的内容',
      //       ),
      //     ),
      //   );
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PersonHomeCirclesCell(
              images: index == 1 ? ['', '', '', ''] : [],
            );
          },
          childCount: 3,
        ),
      );
    });
  }
}

class PersonHomeCirclesCell extends StatelessWidget {
  const PersonHomeCirclesCell({
    Key? key,
    this.userModel,
    this.images,
  }) : super(key: key);

  final UserModel? userModel;

  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像名称时间
          _buildUserInfo(),
          SizedBox(height: 16),
          Text(
            '重磅！Facebook正式改名Meta',
            style: NewsTextStyle.style18BoldBlack,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Text(
            '正文描述正文描述正文描述正文描述正文描述正文描述正文',
            style: NewsTextStyle.style16NormalBlack,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // 图片的展示
          _buildImages(context),
          // 底部按钮
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    String _publishedDate = '昨天';
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userModel?.avatar != null
            ? ClipOval(
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  width: 36,
                  height: 36,
                  imageUrl: STString.addPrefixHttp(userModel?.avatar) ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => NewsImage.defaultAvatar(),
                ),
              )
            : NewsImage.defaultAvatar(),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel?.nickname ?? '林老师',
              style: NewsTextStyle.style14NormalBlack,
            ),
            Text(
              _publishedDate,
              style: NewsTextStyle.style12NormalThrGrey,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildImages(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: _buildSubImages(context),
    );
  }

  Widget _buildSubImages(BuildContext context) {
    if (images == null) {
      return Container();
    } else if (images!.isEmpty || images!.length == 1) {
      return Container(
        color: ColorConfig.baseFourBlue,
        height: 168,
        child: Center(
          child: NewsImage.defaultCircle(),
        ),
      );
    } else {
      return Wrap(
        runSpacing: NewsScale.sh(3, context),
        spacing: NewsScale.sw(3, context),
        children: images!.map((e) {
          return Container(
            color: ColorConfig.baseFourBlue,
            width: NewsScale.sw(112, context),
            height: NewsScale.sw(112, context),
            child: Center(
              child: NewsImage.defaultCircle(height: 50),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          STButton(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(4.0),
            icon: Icon(
              STIcons.commonly_message,
              color: ColorConfig.textSecColor,
            ),
            text: '12',
            textStyle: NewsTextStyle.style14NormalSecGrey,
            onTap: () {},
          ),
          SizedBox(width: 16),
          STButton.icon(
            backgroundColor: Colors.transparent,
            size: STButtonSize.small,
            padding: EdgeInsets.all(4),
            icon: Icon(
              STIcons.commonly_star,
              color: ColorConfig.textSecColor,
            ),
            onTap: () {},
          ),
          SizedBox(width: 16),
          NewsIconTextWidget(
            icon: STIcons.commonly_like,
            unit: '12',
          ),
        ],
      ),
    );
  }
}
