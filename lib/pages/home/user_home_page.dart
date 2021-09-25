import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key, required this.userID}) : super(key: key);

  final String userID;

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<PostModel> _lists = [];
  UserModel? _userModel;
  List<UserModel> _favouriteLists = [];
  bool _isShowPost = true;
  bool _isFavourited = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    Api.getUserInfo(userid: widget.userID).then((result) {
      if (result.success) {
        Map<String, dynamic> _user = result.data['user'];
        _userModel = UserModel.fromJson(_user);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 60,
                      child: STCaCheImage.loadingImage(
                          imageUrl: _userModel?.avatar),
                    ),
                    title: Text(
                      _userModel?.nickname ?? '',
                      style: TextStyle(
                          fontSize: FONTSIZE18, fontWeight: FONTWEIGHT500),
                    ),
                    trailing: STButton(
                      type: STButtonType.outline,
                      size: STButtonSize.small,
                      text: _isFavourited ? '已关注' : '关注',
                      onTap: _changeFavourited,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NewsIconTextWidget(
                            icon: Icons.favorite,
                            title: (_userModel?.favourites ?? 0).toString(),
                            unit: '关注',
                            onTap: () {
                              if (_isShowPost != true) {
                                _isShowPost = true;
                                setState(() {});
                              }
                            }),
                        Container(
                          width: 1,
                          height: 28,
                          color: Color(0xFFDFE2E7),
                        ),
                        NewsIconTextWidget(
                            icon: Icons.favorite_outline,
                            title: (_userModel?.followers ?? 0).toString(),
                            unit: '粉丝',
                            onTap: () {
                              if (_isShowPost != false) {
                                _isShowPost = false;
                                setState(() {});
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _isShowPost ? _buildPost() : _buildFollowers()
        ],
      ),
    );
  }

  SliverList _buildPost() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final _model = _lists[index];
          return Container(
            height: 92,
            child: ListTile(
              title: Text(_model.title ?? ''),
              subtitle: Text(_model.author?.nickname ?? ''),
              trailing: Container(
                width: 102,
                height: 76,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
              ),
              onTap: () {},
            ),
          );
        },
        childCount: _lists.length,
      ),
    );
  }

  SliverList _buildFollowers() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          UserModel _user = _favouriteLists[index];
          return Container(
            height: 56,
            margin: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NewsImage.defaultAvatar(),
                    SizedBox(width: 12),
                    Text(
                      _user.nickname ?? '用户昵称',
                      style: NewsTextStyle.style16NormalBlack,
                    ),
                  ],
                ),
                STButton(
                  type: STButtonType.outline,
                  text: '已关注',
                  borderColor: Color(0xFF888888),
                  textStyle: NewsTextStyle.style16NormalSecGrey,
                  onTap: () {
                    _changeFavouriteStatus(index);
                  },
                ),
              ],
            ),
          );
        },
        childCount: _lists.length,
      ),
    );
  }

  void _changeFavouriteStatus(int index) {
    NewsLoading.start(context);
    UserModel _user = _favouriteLists[index];
    Api.changeUserFavourite(followeduserid: _user.id, status: false)
        .then((result) {
      NewsLoading.stop();
      if (result.success) {
        setState(() {});
      }
    });
  }

  void _changeFavourited() {
    NewsLoading.start(context);
    Api.changeUserFavourite(
            followeduserid: widget.userID, status: !_isFavourited)
        .then((result) {
      if (result.success) {
        _isFavourited = !_isFavourited;
        setState(() {});
      } else {
        STToast.show(context: context, message: result.message);
      }
      NewsLoading.stop();
    });
  }
}
