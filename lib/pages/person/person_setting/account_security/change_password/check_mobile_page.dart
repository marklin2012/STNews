import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/valid_code_button.dart';
import 'package:stnews/pages/person/person_setting/account_security/change_password/edit_password_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

enum checkMobileType {
  changeMobile,
  changePassword,
}

class CheckMobilePage extends StatefulWidget {
  const CheckMobilePage({Key? key, this.type, this.newMobile})
      : assert(type == checkMobileType.changeMobile && newMobile != null),
        super(key: key);

  final checkMobileType? type;

  final String? newMobile;

  @override
  _CheckMobilePageState createState() => _CheckMobilePageState();
}

class _CheckMobilePageState extends State<CheckMobilePage> {
  late TextEditingController _codeCon;
  late checkMobileType _type;

  @override
  void initState() {
    super.initState();
    _codeCon = TextEditingController();
    _type = widget.type ?? checkMobileType.changePassword;
  }

  @override
  void dispose() {
    _codeCon.dispose();
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
        title: Text(_type == checkMobileType.changePassword ? '验证码' : '校验手机号'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          String _mobile;
          if (_type == checkMobileType.changePassword) {
            _mobile = userProvider.user.mobile ?? '';
          } else {
            _mobile = widget.newMobile!;
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '验证码将发送到 ',
                    style: NewsTextStyle.style16NormalBlack,
                  ),
                  Text(STString.removeSpaceAndSecurity(_mobile),
                      style: NewsTextStyle.style16BoldBlack),
                ],
              ),
              SizedBox(height: 18),
              STInput(
                controller: _codeCon,
                inputType: TextInputType.number,
                placeholder: '请输入验证码',
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                suffixIcon: ValidCodeButton(
                  baseStr: '获取验证码',
                  mobile: _mobile,
                ),
              ),
              SizedBox(height: 68),
              STButton(
                text: '确定',
                textStyle: NewsTextStyle.style18BoldWhite,
                radius: 8.0,
                mainAxisSize: MainAxisSize.max,
                onTap: _confirmAction,
              ),
            ],
          );
        }),
      ),
    );
  }

  void _confirmAction() {
    if (_codeCon.text.isEmpty || _codeCon.text.length == 0) {
      STToast.show(context: context, message: '验证码为空');
      return;
    }
    Api.checkCodeVerify(code: _codeCon.text).then((result) {
      if (result.success) {
        if (_type == checkMobileType.changePassword) {
          STRouters.push(context, EditPasswordPage());
        } else {
          Navigator.of(context)
              .popUntil(ModalRoute.withName('/account_security'));
        }
      }
    });
  }
}
