import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/notice_model.dart';

import 'package:stnews/pages/common/person_tile.dart';
import 'package:stnews/pages/person/my_favourite_user_page.dart';
import 'package:stnews/pages/person/my_favourite_post_page.dart';
import 'package:stnews/pages/person/person_home_page.dart';
import 'package:stnews/pages/person/person_info/person_info_page.dart';
import 'package:stnews/pages/person/person_info/show_avatar_page.dart';
import 'package:stnews/pages/person/person_notice/person_notice_page.dart';
import 'package:stnews/pages/person/person_setting/person_setting_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late ValueNotifier<List> _notifier;

  List<NoticeModel> _lists = [];
  bool _isAllReaded = true;

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> _datas = [
      {'icon': STIcons.commonly_home, 'title': '我的主页'},
      {'icon': STIcons.commonly_heart, 'title': '我的收藏'},
      {'icon': STIcons.commonly_star, 'title': '我的关注'},
      {'icon': STIcons.commonly_message, 'title': '消息中心', 'isDot': false},
      {'icon': STIcons.commonly_setting, 'title': '设置'}
    ];
    _notifier = ValueNotifier(_datas);
    _getNotiLists();
  }

  void _getNotiLists() {
    Api.getNotifyList().then((result) {
      if (result.success) {
        List _temps = result.data['noti'] as List;
        _lists = _temps.map((e) => NoticeModel.fromJson(e)).toList();
      }
      for (NoticeModel model in _lists) {
        if (model.isRead == false) {
          _isAllReaded = false;
          break;
        }
      }
      _updateNoti(isAllReaded: _isAllReaded);
    });
  }

  void _updateNoti({bool isAllReaded = true}) {
    List<Map<String, dynamic>> _newDatas = [
      {'icon': STIcons.commonly_home, 'title': '我的主页'},
      {'icon': STIcons.commonly_heart, 'title': '我的收藏'},
      {'icon': STIcons.commonly_star, 'title': '我的关注'},
      {
        'icon': STIcons.commonly_message,
        'title': '消息中心',
        'isDot': !isAllReaded
      },
      {'icon': STIcons.commonly_setting, 'title': '设置'}
    ];
    _notifier.value = _newDatas;
  }

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
              ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, List _values, _) {
                  return Container(
                    height: 52.0 * _values.length - 4.0,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemExtent: 52.0,
                      itemCount: _values.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> _map = _values[index];
                        return Container(
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.only(bottom: 4.0),
                          key: GlobalObjectKey(index),
                          child: PersonTile(
                            data: _map,
                            onTap: () {
                              _goNextPage(index);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
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
        STRouters.push(context, MyFavouritePostPage());
        break;
      case 2:
        // 去我的关注
        STRouters.push(context, MyFavouriteUserPage());
        break;
      case 3:
        // 去消息中心
        STRouters.push(
          context,
          PersonNoticePage(
            notices: _lists,
          ),
        );
        break;
      case 4:
        // 去设置
        STRouters.push(context, PersonSetingPage());
        break;

      default:
    }
  }
}
