import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/person_tile.dart';
import './change_mobile/change_mobile_page.dart';
import './change_password/check_mobile_page.dart';
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
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
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
          );
        }),
      ),
    );
  }

  void _goNextPage(BuildContext context, int index) {
    if (index == 0) {
      STRouters.push(context, ChangeMobilePage());
    } else if (index == 1) {
      STRouters.push(context, CheckMobilePage());
    }
  }
}
