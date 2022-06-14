import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stnews/pages/person/person_widgets/person_tile.dart';
import 'package:stnews/utils/utils+.dart';

import './change_mobile/change_mobile_page.dart';
import 'change_password/check_code_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

// ignore: must_be_immutable
class AccountSecurityPage extends StatelessWidget {
  static String routeName = "account_security";

  AccountSecurityPage({Key? key}) : super(key: key);

  List _datas = [
    {'title': '手机号', 'isSubTitle': ''},
    {'title': '登录密码'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NewsPopBtn.popBtn(context),
        title: Text('账号安全'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        height: 52.0 * _datas.length - 4.0,
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemExtent: 52.0,
            itemCount: _datas.length,
            itemBuilder: (context, index) {
              var _map = _datas[index];
              if (index == 0) {
                var _mobile = STString.removeSpaceAndSecurity(
                    userProvider.user.mobile ?? '');
                _map['isSubTitle'] = _mobile;
              }
              return PersonTile(
                data: _map,
                onTap: () {
                  _goNextPage(context, index);
                },
              );
            },
          );
        }),
      ),
    );
  }

  void _goNextPage(BuildContext context, int index) {
    if (index == 0) {
      STRouters.push(
        context,
        ChangeMobilePage(),
        direction: STRoutersDirection.rightToLeft,
      );
    } else if (index == 1) {
      STRouters.push(
        context,
        CheckCodePage(),
        direction: STRoutersDirection.rightToLeft,
      );
    }
  }
}
