import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class MyFavouriteUserPage extends StatefulWidget {
  const MyFavouriteUserPage({Key? key}) : super(key: key);

  @override
  _MyFavouriteUserPageState createState() => _MyFavouriteUserPageState();
}

class _MyFavouriteUserPageState extends State<MyFavouriteUserPage> {
  @override
  void initState() {
    super.initState();
    _getFavouritesData();
  }

  void _getFavouritesData() {
    Api.getFavourite().then((result) {
      if (result.success) {}
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
        title: Text('我的关注'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemExtent: 56,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '用户昵称',
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
      ),
    );
  }

  void _changeFavouriteStatus(int index) {
    Api.changeUserFavourite().then((reslut) {
      if (reslut.success) {}
    });
  }
}
