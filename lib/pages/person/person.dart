import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/person_tile.dart';
import 'package:stnews/pages/person/person_collect_page.dart';
import 'package:stnews/pages/person/person_home_page.dart';
import 'package:stnews/pages/person/person_info/person_info_page.dart';
import 'package:stnews/pages/person/person_info/show_avatar_page.dart';
import 'package:stnews/pages/person/person_like_page.dart';
import 'package:stnews/pages/person/person_notice/person_notice_page.dart';
import 'package:stnews/pages/person/person_setting/person_setting_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  List<Map> _datas = [
    {'icon': STIcons.commonly_message, 'title': '我的主页'},
    {'icon': STIcons.commonly_star, 'title': '我的收藏'},
    {'icon': STIcons.commonly_star, 'title': '我的关注'},
    {'icon': STIcons.commonly_star, 'title': '消息中心', 'isDot': true},
    {'icon': STIcons.commonly_setting, 'title': '设置'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 44.0),
          child: Column(
            children: [
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // 查看头像
                      STRouters.push(context, ShowAvatarPage());
                    },
                    child: Hero(
                      tag: ShowAvatarPage.HeroTag,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor,
                        ),
                        child: STCaCheImage.loadingImage(
                          imageUrl: userProvider.user.avatar,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userProvider.user.nickname ?? '登录/注册',
                    style: NewsTextStyle.style18BoldBlack,
                  ),
                  trailing: Icon(
                    STIcons.direction_rightoutlined,
                    size: 16,
                  ),
                  onTap: () {
                    // 去个人信息
                    STRouters.push(context, PersonInfoPage());
                  },
                );
              }),
              SizedBox(height: 50),
              Container(
                height: 52.0 * _datas.length - 4.0,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemExtent: 52.0,
                  itemCount: _datas.length,
                  itemBuilder: (context, index) {
                    final _map = _datas[index];
                    return Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: PersonTile(
                        data: _map,
                        onTap: () {
                          _goNextPage(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goNextPage(int index) {
    switch (index) {
      case 0:
        // 去我的主页
        STRouters.push(context, PersonHomePage());
        break;
      case 1:
        // 去我的收藏
        STRouters.push(context, PersonCollectPage());
        break;
      case 2:
        // 去我的关注
        STRouters.push(context, PersonLikePage());
        break;
      case 3:
        // 去消息中心
        STRouters.push(context, PersonNoticePage());
        break;
      case 4:
        // 去设置
        STRouters.push(context, PersonSetingPage());
        break;

      default:
    }
  }
}
