import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/st_badge/badge_positoned.dart';
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
              onSubmitted: (String value) {},
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
            backgroundColor: _isFavourited ? Colors.blue : Colors.transparent,
            icon: Icon(
              STIcons.commonly_star,
            ),
            onTap: _favouritedPost,
          ),
          STButton.icon(
            padding: EdgeInsets.all(2.0),
            backgroundColor: _isLiked ? Colors.blue : Colors.transparent,
            icon: Icon(STIcons.commonly_like),
            onTap: _likedPost,
          )
        ],
      ),
    );
  }

  /// 收藏或取消收藏该文章
  void _favouritedPost() {
    final model = PostDetailInheritedWidget.of(context).valueNotifier.value;
    Api.favoritePost(postid: model.id, status: !_isFavourited).then((result) {
      if (result.success) {
        _isFavourited = !_isFavourited;
        setState(() {});
      }
    });
  }

  /// 点赞或取消点赞该文章
  void _likedPost() {}
}
