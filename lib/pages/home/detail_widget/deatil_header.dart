import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/post_detail_inherited.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
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
  bool _isFavourite = false;
  late PostModel _model;
  List<UserModel> _favouriteLists = [];

  @override
  void initState() {
    super.initState();
    _getFavouritedUser();
  }

  /// 查询是否关注了该用户
  void _getFavouritedUser() {
    Api.getUserFavouriteList().then((result) {
      if (result.success) {
        List _temp = result.data['favourites'];
        _favouriteLists = _temp.map((e) => UserModel.fromJson(e)).toList();
        for (UserModel user in _favouriteLists) {
          if (user.id == _model.author?.id) {
            _isFavourite = true;
            break;
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _model = PostDetailInheritedWidget.of(context)!.valueNotifier.value;
    String _publishDate = '';
    if (_model.publishdate != null) {
      DateTime _temp =
          STString.dateTimeFromString(dateStr: _model.publishdate!);
      _publishDate = STString.getDateString(_temp);
    }

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
                        _model.author?.nickname ?? '',
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
              if (_model.author?.id != null &&
                  _model.author?.id! != UserProvider.shared.user.id)
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
    NewsLoading.start(context);
    Api.changeUserFavourite(
            followeduserid: _model.author?.id, status: !_isFavourite)
        .then((reslut) {
      NewsLoading.stop();
      if (reslut.success) {
        _isFavourite = !_isFavourite;
        setState(() {});
      } else {
        STToast.show(context: context, message: reslut.message);
      }
    });
  }
}
