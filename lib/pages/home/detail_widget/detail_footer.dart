import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

class DetailFooterData {
  DetailFooterData({
    this.isCommited = true,
    this.isFavourited = false,
    this.isLiked = false,
    this.isReplyed = false,
    this.replyNickName,
    this.commentedCount,
  });

  bool isCommited;
  bool isFavourited;
  bool isLiked;
  bool isReplyed;
  String? replyNickName;
  String? commentedCount;

  DetailFooterData.init(
      {this.isCommited = true,
      this.isFavourited = false,
      this.isLiked = false,
      this.isReplyed = false,
      this.replyNickName,
      this.commentedCount});

  DetailFooterData setFavPost(bool isFav) {
    return DetailFooterData(
      isCommited: this.isCommited,
      isFavourited: isFav,
      isLiked: this.isLiked,
      isReplyed: false,
      commentedCount: this.commentedCount,
    );
  }

  DetailFooterData setLikePost(bool isLike) {
    return DetailFooterData(
      isCommited: this.isCommited,
      isFavourited: this.isFavourited,
      isLiked: isLike,
      isReplyed: false,
      commentedCount: this.commentedCount,
    );
  }

  DetailFooterData setCommited(bool isCommit) {
    return DetailFooterData(
      isCommited: isCommit,
      isFavourited: this.isFavourited,
      isLiked: this.isLiked,
      isReplyed: false,
      commentedCount: this.commentedCount,
    );
  }

  DetailFooterData setCommentCount(String commentCounts) {
    return DetailFooterData(
      isCommited: this.isCommited,
      isFavourited: this.isFavourited,
      isLiked: this.isLiked,
      isReplyed: this.isReplyed,
      commentedCount: commentCounts,
    );
  }

  DetailFooterData setCommentAndCommited(String commentCounts) {
    return DetailFooterData(
      isCommited: true,
      isFavourited: this.isFavourited,
      isLiked: this.isLiked,
      isReplyed: false,
      commentedCount: commentCounts,
    );
  }

  DetailFooterData setReplyed(bool isReply, {String? nickName}) {
    return DetailFooterData(
      isCommited: false,
      isFavourited: this.isFavourited,
      isLiked: this.isLiked,
      isReplyed: isReply,
      replyNickName: nickName,
      commentedCount: this.commentedCount,
    );
  }
}

class DetailFooter extends StatefulWidget {
  const DetailFooter({
    Key? key,
    required this.data,
    required this.switchCommitTap,
    this.messageTap,
    this.commentTap,
    this.favouriteTap,
    this.likeTap,
  }) : super(key: key);

  final DetailFooterData data;
  final Function()? messageTap;
  final Function(bool) switchCommitTap;
  final Function(bool)? favouriteTap;
  final Function(bool)? likeTap;
  final Function(String)? commentTap;

  @override
  _DetailFooterState createState() => _DetailFooterState();
}

class _DetailFooterState extends State<DetailFooter> {
  late TextEditingController _controller;

  late ValueNotifier<bool> _sendEnableNoti;

  FocusNode _commentFocus = FocusNode();

  late DetailFooterData _data;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _data = widget.data;

    if (_data.isCommited) {
      _controller.text = '';
      return _buildNormal();
    } else {
      Future.delayed(Duration(milliseconds: 50), () {
        FocusScope.of(context).requestFocus(_commentFocus);
      });
      return _buildEditComments();
    }
  }

  Widget _buildNormal() {
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
                widget.switchCommitTap(false);
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
                if (widget.messageTap != null) {
                  widget.messageTap!();
                }
              },
            ),
            value: _data.commentedCount,
          ),
          SizedBox(
            width: 20,
          ),
          STButton.icon(
            padding: EdgeInsets.all(6.0),
            backgroundColor: Colors.transparent,
            icon: _data.isFavourited
                ? Image(
                    width: 24,
                    height: 24,
                    image: AssetImage('assets/images/favourited.png'),
                  )
                : Icon(
                    STIcons.commonly_star,
                  ),
            onTap: () {
              if (widget.favouriteTap != null) {
                widget.favouriteTap!(_data.isFavourited);
              }
            },
          ),
          SizedBox(
            width: 16,
          ),
          STButton.icon(
            padding: EdgeInsets.all(6.0),
            backgroundColor: Colors.transparent,
            icon: _data.isLiked
                ? Image(
                    width: 24,
                    height: 24,
                    image: AssetImage('assets/images/liked.png'),
                  )
                : Icon(STIcons.commonly_like),
            onTap: () {
              if (widget.likeTap != null) {
                widget.likeTap!(_data.isLiked);
              }
            },
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
        widget.switchCommitTap(true);
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
                  hintText:
                      _data.isReplyed ? '回复 ${_data.replyNickName}:' : '发表评论',
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
                    debounceTime: 200,
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
    if (widget.commentTap != null) {
      widget.commentTap!(content);
    }
  }
}
