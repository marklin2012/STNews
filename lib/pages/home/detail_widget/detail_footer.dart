import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/st_badge/badge_positoned.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/post_detail_inherited.dart';
import 'package:stnews/service/api.dart';

class DetailFooter extends StatefulWidget {
  const DetailFooter(
      {Key? key,
      this.messageValue = '0',
      this.isFavourited,
      this.isLiked,
      this.messageTap})
      : super(key: key);

  final String? messageValue;

  final bool? isFavourited;

  final bool? isLiked;

  final Function()? messageTap;

  @override
  _DetailFooterState createState() => _DetailFooterState();
}

class _DetailFooterState extends State<DetailFooter> {
  late bool _isFavourited;
  late bool _isLiked;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isFavourited = widget.isFavourited ?? false;
    _isLiked = widget.isLiked ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                color: Color(0xFFEFF3F9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              placeholder: '发表评论',
              controller: _controller,
              onSubmitted: (String value) {
                _addComment(value);
              },
            ),
          ),
          STBadge(
            position: STBadgePosition(top: -6, end: -15),
            child: STButton.icon(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              icon: Icon(STIcons.commonly_message),
              onTap: () {
                if (widget.messageTap != null) {
                  widget.messageTap!();
                }
              },
            ),
            value: widget.messageValue,
          ),
          STButton.icon(
            padding: EdgeInsets.all(2.0),
            backgroundColor:
                _isFavourited ? Color(0xFFFFA927) : Colors.transparent,
            icon: Icon(
              STIcons.commonly_star,
            ),
            onTap: _favouritedPost,
          ),
          STButton.icon(
            padding: EdgeInsets.all(2.0),
            backgroundColor: _isLiked ? Color(0xFFFF4141) : Colors.transparent,
            icon: Icon(STIcons.commonly_like),
            onTap: _likedPost,
          )
        ],
      ),
    );
  }

  /// 发布评论
  void _addComment(String? content) async {
    if (content == null) return;
    final model = PostDetailInheritedWidget.of(context).valueNotifier.value;
    NewsLoading.start(context);
    Api.addComment(postid: model.id, content: content).then((result) {
      NewsLoading.stop();
      if (result.success) {
        _controller.text = '';
      }
    });
  }

  /// 收藏或取消收藏该文章
  void _favouritedPost() async {
    final model = PostDetailInheritedWidget.of(context).valueNotifier.value;
    NewsLoading.start(context);
    Api.favoritePost(postid: model.id, status: !_isFavourited).then((result) {
      NewsLoading.stop();
      if (result.success) {
        _isFavourited = !_isFavourited;
        setState(() {});
      } else {
        STToast.show(
            context: context, message: _isFavourited ? '取消收藏失败' : '收藏失败');
      }
    });
  }

  /// 点赞或取消点赞该文章
  void _likedPost() {
    final model = PostDetailInheritedWidget.of(context).valueNotifier.value;
    NewsLoading.start(context);
    Api.thumbupPost(post: model.id, status: !_isLiked).then((result) {
      NewsLoading.stop();
      if (result.success) {
        _isLiked = !_isLiked;
        setState(() {});
      } else {
        STToast.show(context: context, message: _isLiked ? '取消点赞失败' : '点赞失败');
      }
    });
  }
}
