import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class PostDetailHeaderData {
  String? publishedDate;
  String? title;
  String? authorAvatar;
  String? authorNickName;
  String? authorId;
  bool? isFavedUser;

  PostDetailHeaderData({
    this.publishedDate,
    this.title,
    this.authorAvatar,
    this.authorNickName,
    this.authorId,
    this.isFavedUser,
  });

  PostDetailHeaderData setFavedUser(bool isFaved) {
    return PostDetailHeaderData(
      publishedDate: this.publishedDate,
      title: this.title,
      authorAvatar: this.authorAvatar,
      authorNickName: this.authorNickName,
      authorId: this.authorId,
      isFavedUser: isFaved,
    );
  }
}

const double detailHeaderHeight = 186;

class DetailHeader extends StatefulWidget {
  const DetailHeader({
    Key? key,
    this.authorTap,
    this.onFavouritedUser,
    required this.offset,
    required this.data,
  }) : super(key: key);
  final double offset;
  final Function()? authorTap;
  final Function(bool)? onFavouritedUser;
  final PostDetailHeaderData data;

  @override
  _DetailHeaderState createState() => _DetailHeaderState();
}

class _DetailHeaderState extends State<DetailHeader> {
  ValueNotifier<bool> _loadingNoti = ValueNotifier(false);
  PostDetailHeaderData _lastData = PostDetailHeaderData();

  @override
  void initState() {
    super.initState();
    _lastData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    if (_lastData.isFavedUser != widget.data.isFavedUser) {
      _loadingNoti.value = false;
      _lastData = widget.data;
    }
    String _publishedDate = '';
    if (widget.data.publishedDate != null) {
      DateTime _temp =
          STString.dateTimeFromString(dateStr: widget.data.publishedDate!);
      _publishedDate = STString.getDateString(_temp);
    }
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 44,
              child: Row(
                children: [
                  IconButton(
                    iconSize: 24,
                    icon: Icon(
                      STIcons.direction_leftoutlined,
                      color: ColorConfig.textFirColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.offset / detailHeaderHeight * 80),
                    child: Opacity(
                      opacity: _calculateTitleOpacity(),
                      child: Text(
                        widget.data.title ?? '',
                        style: NewsTextStyle.style28BoldBlack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: widget.offset / detailHeaderHeight * 32,
                              height: 44,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          STButton.icon(
                            padding: EdgeInsets.zero,
                            icon: ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: NewsImage.networkImage(
                                path: widget.data.authorAvatar,
                                width: 36,
                                height: 36,
                                defaultChild: NewsImage.defaultAvatar(),
                              ),
                            ),
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
                                widget.data.authorNickName ?? '',
                                style: NewsTextStyle.style14NormalBlack,
                              ),
                              if (widget.offset < 125)
                                Opacity(
                                  opacity:
                                      1 - widget.offset / detailHeaderHeight,
                                  child: Text(
                                    _publishedDate,
                                    style: NewsTextStyle.style12NormalThrGrey,
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                      if (widget.data.authorId != null &&
                          widget.data.authorId! != UserProvider.shared.user.id)
                        ValueListenableBuilder(
                            valueListenable: _loadingNoti,
                            builder: (context, bool loading, _) {
                              return STButton(
                                type: STButtonType.outline,
                                height: 30,
                                loading: loading,
                                loadingIconSize: 15,
                                padding: EdgeInsets.fromLTRB(16, 3, 16, 3),
                                text: (widget.data.isFavedUser ?? false)
                                    ? '已关注'
                                    : '关注',
                                textStyle: (widget.data.isFavedUser ?? false)
                                    ? NewsTextStyle.style14NormalThrGrey
                                    : NewsTextStyle.style14NormalFirBlue,
                                borderColor: (widget.data.isFavedUser ??
                                        false || !loading)
                                    ? ColorConfig.textThrColor
                                    : ColorConfig.baseFirBule,
                                onTap: () {
                                  _loadingNoti.value = true;
                                  if (widget.onFavouritedUser != null) {
                                    widget.onFavouritedUser!(
                                        widget.data.isFavedUser ?? false);
                                  }
                                },
                              );
                            })
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTitleOpacity() {
    if (widget.offset < detailHeaderHeight / 2) {
      return 1 - widget.offset / detailHeaderHeight * 2;
    } else {
      return 0;
    }
  }
}
