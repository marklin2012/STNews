import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/utils/news_text_style.dart';

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

  late ValueNotifier<bool> _sendEnableNoti;

  FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        if (_controller.text.isNotEmpty || _controller.text.length > 0) {
          _sendEnableNoti.value = true;
        } else {
          _sendEnableNoti.value = false;
        }
      });
    bool _sendEnable = false;
    _sendEnableNoti = ValueNotifier(_sendEnable);
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
      return Stack(
        children: [
          Opacity(
            opacity: postDetP.footerShowEdit ? 1.0 : 0.0,
            child: _buildEditComments(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: postDetP.footerShowEdit ? 0.0 : 1.0,
              child: _buildNormal(postDetP),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNormal(PostDetailProvider postDetP) {
    return Container(
      height: 44.0,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(_commentFocus);
                postDetP.footerShowEdit = true;
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: ColorConfig.fourGrey,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  '发表评论',
                  style: NewsTextStyle.style14NormalFourGrey,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 24,
          ),
          STBadge(
            child: STButton.icon(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              icon: Icon(STIcons.commonly_message),
              onTap: () {
                if (postDetP.footerShowEdit) return;
                if (widget.messageTap != null) {
                  widget.messageTap!();
                }
              },
            ),
            value: postDetP.comments.length.toString(),
          ),
          SizedBox(
            width: 24,
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
          SizedBox(
            width: 24,
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
          ),
          SizedBox(
            width: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildEditComments() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _commentFocus.unfocus();
        postDetailProvider.footerShowEdit = false;
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        color: ColorConfig.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: ColorConfig.fourGrey,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _commentFocus,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintMaxLines: 1,
                  hintText: '发表评论',
                  hintStyle: NewsTextStyle.style14NormalFourGrey,
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(500),
                ],
              ),
            )),
            SizedBox(width: 8.0),
            ValueListenableBuilder(
                valueListenable: _sendEnableNoti,
                builder: (context, bool value, _) {
                  return STButton(
                    disabled: !value,
                    text: '发送',
                    textStyle: NewsTextStyle.style16NormalWhite,
                    onTap: () {
                      _addComment(_controller.text);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  /// 发布评论
  void _addComment(String? content) async {
    if (content == null || content.isEmpty) {
      STToast.show(context: context, message: '评论不可为空');
      return;
    }
    // NewsLoading.start(context);
    bool isSuc = await postDetailProvider.addComment(content);
    if (isSuc) {
      _controller.text = '';
      _commentFocus.unfocus();
      postDetailProvider.footerShowEdit = false;
    }
    // NewsLoading.stop();
  }

  /// 收藏或取消收藏该文章
  void _favouritedPost() async {
    if (postDetailProvider.footerShowEdit) return;
    // NewsLoading.start(context);
    await postDetailProvider.favouritedPost();
    // NewsLoading.stop();
  }

  /// 点赞或取消点赞该文章
  void _likedPost() async {
    if (postDetailProvider.footerShowEdit) return;
    // NewsLoading.start(context);
    await postDetailProvider.likedPost();
    // NewsLoading.stop();
  }
}
