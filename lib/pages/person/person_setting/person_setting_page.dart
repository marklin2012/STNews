import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/person_tile.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/pages/person/person_setting/about_me/about_me_page.dart';
import 'package:stnews/pages/person/person_setting/account_security/account_security_page.dart';
import 'package:stnews/pages/person/person_setting/feedback_suggestion/feedback_suggestion_page.dart';
import 'package:stnews/pages/person/person_setting/message_setting_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

const _datas = [
  {'icon': STIcons.commonly_setting, 'title': '账号安全'},
  {'icon': STIcons.commonly_setting, 'title': '消息设置'},
  {'icon': STIcons.commonly_setting, 'title': '反馈与建议'},
  {'icon': STIcons.commonly_setting, 'title': '关于我们'}
];

class PersonSetingPage extends StatelessWidget {
  const PersonSetingPage({Key? key}) : super(key: key);

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
        title: Text('设置'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        child: Column(
          children: [
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
                        _goNextPage(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 68),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: STButton(
                text: '退出登录',
                textStyle: NewsTextStyle.style18BoldWhite,
                radius: 8.0,
                mainAxisSize: MainAxisSize.max,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context1) {
                      return CupertinoAlertDialog(
                        title: Text(
                          '退出登录',
                          style: NewsTextStyle.style18BoldBlack,
                        ),
                        content: Text(
                          '退出当前账号，将不能同步收藏和回复/评论等',
                          style: NewsTextStyle.style16NormalBlack,
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(
                              '取消',
                              style: NewsTextStyle.style16NormalFirBlue,
                            ),
                            onPressed: () {
                              Navigator.of(context1).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text(
                              '确定',
                              style: NewsTextStyle.style16BoldFirBlue,
                            ),
                            onPressed: () {
                              UserProvider.shared
                                  .setToken(null, isReload: true);
                              Navigator.of(context1).pop();
                              STRouters.push(context, LoginPage());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goNextPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        // 账号安全
        STRouters.push(context, AccountSecurityPage(),
            routeName: AccountSecurityPage.routeName);
        break;
      case 1:
        //消息设置
        STRouters.push(context, MessageSettingPage());
        break;
      case 2:
        //反馈与建议
        STRouters.push(context, FeedbackSuggestionPage());
        break;
      case 3:
        //关于我们
        STRouters.push(context, AboutMePage());
        break;
      default:
        break;
    }
  }
}
