import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class MyFavouriteUserPage extends StatefulWidget {
  const MyFavouriteUserPage({Key? key}) : super(key: key);

  @override
  _MyFavouriteUserPageState createState() => _MyFavouriteUserPageState();
}

class _MyFavouriteUserPageState extends State<MyFavouriteUserPage> {
  late List<UserModel> _favouriteLists = [];

  @override
  void initState() {
    super.initState();
    _getFavouritesData();
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
        title: Text('我的关注'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_favouriteLists.isEmpty) return EmptyViewWidget(content: '暂无任何关注');
    return Container(
      margin: EdgeInsets.only(top: 24.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
          itemExtent: 56,
          itemCount: _favouriteLists.length,
          itemBuilder: (context, index) {
            UserModel _user = _favouriteLists[index];
            return Container(
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
          }),
    );
  }

  void _getFavouritesData() {
    Api.getUserFavouriteList().then((result) {
      if (result.success) {
        List _temp = result.data['favourites'];
        _favouriteLists = _temp.map((e) => UserModel.fromJson(e)).toList();
        setState(() {});
      }
    });
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
}
