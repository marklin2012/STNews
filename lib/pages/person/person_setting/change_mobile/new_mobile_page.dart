import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/login/phone_input.dart';
import 'package:stnews/pages/person/person_setting/change_mobile/new_mobile_code_page.dart';
import 'package:stnews/utils/st_routers.dart';

class NewMobilePage extends StatefulWidget {
  const NewMobilePage({Key? key}) : super(key: key);

  @override
  _NewMobilePageState createState() => _NewMobilePageState();
}

class _NewMobilePageState extends State<NewMobilePage> {
  late String _areaStr;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _areaStr = '86';
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        title: Text('新的手机号'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 32),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            PhoneInput(
              areaStr: _areaStr,
              controller: _controller,
              placeholder: '请输入新的手机号',
            ),
            SizedBox(height: 68),
            STButton(
              text: '下一步',
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: FONTSIZE18,
                fontWeight: FONTWEIGHT500,
              ),
              mainAxisSize: MainAxisSize.max,
              onTap: () {
                STRouters.push(context, NewMobileCodePage());
              },
            )
          ],
        ),
      ),
    );
  }
}
