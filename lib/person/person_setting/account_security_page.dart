import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/person/person_setting/change_mobile/change_mobile_page.dart';
import 'package:stnews/person/person_setting/edit_password_page.dart';
import 'package:stnews/person/subview/person_tile.dart';
import 'package:stnews/utils/st_routers.dart';

const _datas = [
  {'title': '手机号', 'isSubTitle': '187******68'},
  {'title': '登录密码'}
];

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({Key? key}) : super(key: key);

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
    );
  }

  void _goNextPage(BuildContext context, int index) {
    if (index == 0) {
      STRouters.push(context, ChangeMobilePage());
    } else if (index == 1) {
      STRouters.push(context, EditPasswordPage());
    }
  }
}
