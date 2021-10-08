import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/post_detail_provider.dart';

class DetailFooter extends StatefulWidget {
  const DetailFooter({
    Key? key,
    this.messageTap,
  }) : super(key: key);

  final Function()? messageTap;

  @override
  _DetailFooterState createState() => _DetailFooterState();
}

class _DetailFooterState extends State<DetailFooter> {
  late TextEditingController _controller;

  PostDetailProvider get postDetailProvider =>
      Provider.of<PostDetailProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    postDetailProvider.getPostFavouritedAndLiked();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(builder: (context, postDetP, _) {
      return Container(
        height: 44.0,
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 211,
              child: STInput(
                decoration: BoxDecoration(
                  color: ColorConfig.fourGrey,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.zero,
                placeholder: '发表评论',
                controller: _controller,
                onSubmitted: (String value) {
                  _addComment(value);
                },
              ),
            ),
            STBadge(
              child: STButton.icon(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                icon: Icon(STIcons.commonly_message),
                onTap: () {
                  if (widget.messageTap != null) {
                    widget.messageTap!();
                  }
                },
              ),
              value: postDetP.comments.length.toString(),
            ),
            STButton.icon(
              padding: EdgeInsets.all(2.0),
              backgroundColor: Colors.transparent,
              icon: postDetP.isFavouritedPost
                  ? Image(
                      width: 24,
                      height: 24,
                      image: AssetImage('assets/images/favourited.png'),
                    )
                  : Icon(
                      STIcons.commonly_star,
                    ),
              onTap: _favouritedPost,
            ),
            STButton.icon(
              padding: EdgeInsets.all(2.0),
              backgroundColor: Colors.transparent,
              icon: postDetP.isLikedPost
                  ? Image(
                      width: 24,
                      height: 24,
                      image: AssetImage('assets/images/liked.png'),
                    )
                  : Icon(STIcons.commonly_like),
              onTap: _likedPost,
            )
          ],
        ),
      );
    });
  }

  /// 发布评论
  void _addComment(String? content) async {
    if (content == null || content.isEmpty) {
      STToast.show(context: context, message: '评论不可为空');
      return;
    }
    NewsLoading.start(context);
    bool isSuc = await postDetailProvider.addComment(content);
    NewsLoading.stop();
    if (isSuc) {
      _controller.text = '';
    }
  }

  /// 收藏或取消收藏该文章
  void _favouritedPost() async {
    NewsLoading.start(context);
    await postDetailProvider.favouritedPost();
    NewsLoading.stop();
  }

  /// 点赞或取消点赞该文章
  void _likedPost() async {
    NewsLoading.start(context);
    await postDetailProvider.likedPost();
    NewsLoading.stop();
  }
}
