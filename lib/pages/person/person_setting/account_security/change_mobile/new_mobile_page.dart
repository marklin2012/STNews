import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/login/phone_input.dart';
import 'package:stnews/pages/person/person_setting/account_security/change_password/check_code_page.dart';
import 'package:stnews/utils/news_text_style.dart';
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
              textStyle: NewsTextStyle.style18BoldWhite,
              mainAxisSize: MainAxisSize.max,
              onTap: () {
                if (_controller.text.isEmpty) {
                  STToast.show(context: context, message: '手机号为空');
                  return;
                }
                STRouters.push(
                    context,
                    CheckCodePage(
                      type: checkCodeType.changeMobile,
                      newMobile: _controller.text,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
