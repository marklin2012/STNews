import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/providers/favourited_user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class MyFavouriteUserPage extends StatefulWidget {
  const MyFavouriteUserPage({Key? key}) : super(key: key);

  @override
  _MyFavouriteUserPageState createState() => _MyFavouriteUserPageState();
}

class _MyFavouriteUserPageState extends State<MyFavouriteUserPage> {
  FavouritedUserProvider get favUserProvider =>
      Provider.of<FavouritedUserProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    favUserProvider.getFavouritedUsers();
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
    return Consumer<FavouritedUserProvider>(builder: (context, favUserP, _) {
      if (favUserP.users.isEmpty) {
        return EmptyViewWidget(content: '暂无任何关注');
      }
      return Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemExtent: 56,
            itemCount: favUserP.users.length,
            itemBuilder: (context, index) {
              UserModel _user = favUserP.users[index];
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
    });
  }

  void _changeFavouriteStatus(int index) {
    NewsLoading.start(context);
    favUserProvider.changeFavouritedUserStatus(index);
    NewsLoading.stop();
  }
}
