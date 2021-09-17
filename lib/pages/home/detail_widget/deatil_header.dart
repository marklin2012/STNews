import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/post_detail_inherited.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';

class DetailHeader extends StatefulWidget {
  const DetailHeader({Key? key, this.isFavourited, this.authorTap})
      : super(key: key);

  final bool? isFavourited;

  final Function()? authorTap;

  @override
  _DetailHeaderState createState() => _DetailHeaderState();
}

class _DetailHeaderState extends State<DetailHeader> {
  late bool _isFavourite;
  late PostModel _model;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.isFavourited ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _model = PostDetailInheritedWidget.of(context).valueNotifier.value;
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _model.title ?? '',
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
                        _model.author ?? '',
                        style: NewsTextStyle.style14NormalBlack,
                      ),
                      Text(
                        _model.publishdate ?? '',
                        style: NewsTextStyle.style12NormalThrGrey,
                      ),
                    ],
                  )
                ],
              ),
              STButton(
                type: STButtonType.outline,
                text: _isFavourite ? '已关注' : '关注',
                textStyle: NewsTextStyle.style16NormalFirBlue,
                onTap: _favouritedUser,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 关注或取消关注该用户
  void _favouritedUser() {
    Api.changeUserFavourite(
            followeduserid: _model.author, status: !_isFavourite)
        .then((reslut) {
      if (reslut.success) {
        _isFavourite = !_isFavourite;
        setState(() {});
      }
    });
  }
}
