import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class DetailHeader extends StatefulWidget {
  const DetailHeader({Key? key, this.authorTap}) : super(key: key);

  final Function()? authorTap;

  @override
  _DetailHeaderState createState() => _DetailHeaderState();
}

class _DetailHeaderState extends State<DetailHeader> {
  PostDetailProvider get postDetailProvider =>
      Provider.of<PostDetailProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    postDetailProvider.getFavouritedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(builder: (context, postDetP, _) {
      String _publishDate = '';
      if (postDetP.postModel.publishdate != null) {
        DateTime _temp = STString.dateTimeFromString(
            dateStr: postDetP.postModel.publishdate!);
        _publishDate = STString.getDateString(_temp);
      }
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              postDetP.postModel.title ?? '',
              style: NewsTextStyle.style28BoldBlack,
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    STButton.icon(
                      padding: EdgeInsets.zero,
                      icon: NewsImage.defaultAvatar(),
                      onTap: () {
                        if (widget.authorTap != null) {
                          widget.authorTap!();
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
                        Text(
                          _publishDate,
                          style: NewsTextStyle.style12NormalThrGrey,
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
                    text: postDetP.isFavouritedUser ? '已关注' : '关注',
                    textStyle: NewsTextStyle.style16NormalFirBlue,
                    onTap: _favouritedUser,
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// 关注或取消关注该用户
  Future _favouritedUser() async {
    NewsLoading.start(context);
    await postDetailProvider.favouritedUser();
    NewsLoading.stop();
  }
}
