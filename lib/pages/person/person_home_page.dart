import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonHomePage extends StatefulWidget {
  const PersonHomePage({Key? key, this.userID}) : super(key: key);

  final String? userID;

  @override
  _PersonHomePageState createState() => _PersonHomePageState();
}

class _PersonHomePageState extends State<PersonHomePage> {
  UserInfoModel _infoModel = UserInfoModel();
  late bool _isSelf;
  bool _isFavouritedUser = false;

  @override
  void initState() {
    super.initState();
    _isSelf = widget.userID == UserProvider.shared.user.id;
    if (widget.userID == null) _isSelf = true;
    _getUserData();
    _getFavouritedUser();
  }

  void _getUserData() {
    Api.getUserInfo(userid: widget.userID).then((result) {
      if (result.success) {
        Map<String, dynamic> _userInfo = result.data;
        _infoModel = UserInfoModel.fromJson(_userInfo);
        setState(() {});
      }
    });
  }

  void _getFavouritedUser() {
    Api.getUserFavouriteList().then((result) {
      if (result.success) {
        List _temp = result.data['favourites'];
        List<UserModel> _favouriteLists =
            _temp.map((e) => UserModel.fromJson(e)).toList();
        for (var item in _favouriteLists) {
          if (item.id == widget.userID) {
            _isFavouritedUser = true;
            break;
          }
        }
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
            child: _buildHeader(),
          ),
          if (_infoModel.post != null && _infoModel.post!.isNotEmpty)
            _buildPost(),
          if (_infoModel.post == null ||
              (_infoModel.post != null && _infoModel.post!.isEmpty))
            SliverToBoxAdapter(
              child: EmptyViewWidget(
                content: '暂无发布的内容',
              ),
            )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              height: 60,
              child:
                  STCaCheImage.loadingImage(imageUrl: _infoModel.user?.avatar),
            ),
            title: Text(
              _infoModel.user?.nickname ?? '',
              style: TextStyle(fontSize: FONTSIZE18, fontWeight: FONTWEIGHT500),
            ),
            trailing: _isSelf
                ? null
                : STButton(
                    text: _isFavouritedUser ? '已关注' : '关注',
                    type: STButtonType.outline,
                    size: STButtonSize.small,
                    onTap: _changeFavouriteStatus,
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
                    title: (_infoModel.user?.favourites ?? 0).toString(),
                    unit: '关注',
                    onTap: () {}),
                Container(
                  width: 1,
                  height: 28,
                  color: Color(0xFFDFE2E7),
                ),
                NewsIconTextWidget(
                    icon: Icons.favorite_outline,
                    title: (_infoModel.user?.followers ?? 0).toString(),
                    unit: '粉丝',
                    onTap: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  SliverList _buildPost() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final _model = _infoModel.post?[index];
          return Container(
            height: 92,
            child: ListTile(
              title: Text(_model?.title ?? ''),
              subtitle: Text(_model?.author?.nickname ?? ''),
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
        childCount: _infoModel.post?.length,
      ),
    );
  }

  void _changeFavouriteStatus() {
    NewsLoading.start(context);
    Api.changeUserFavourite(
            followeduserid: widget.userID, status: !_isFavouritedUser)
        .then((result) {
      NewsLoading.stop();
      if (result.success) {
        _isFavouritedUser = !_isFavouritedUser;
        setState(() {});
      }
    });
  }
}
