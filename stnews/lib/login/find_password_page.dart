import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/login/area_code_page.dart';
import 'package:stnews/login/new_password_page.dart';
import 'package:stnews/login/phone_input.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/valid_code_button.dart';

const _horFix16 = 16.0;
const _spaceFix34 = 34.0;
const _spaceFix36 = 36.0;
const _spaceFix46 = 46.0;

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({Key? key, this.areaCode}) : super(key: key);

  final Map<String, String>? areaCode;

  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  var _selectedArea = {};
  var _btnDisable = true;

  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _codeCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedArea = widget.areaCode ?? {"中国": "86"};
    _phoneCon.addListener(() {
      if (_phoneCon.text.isNotEmpty && _codeCon.text.isNotEmpty) {
        _btnDisable = false;
      } else {
        _btnDisable = true;
      }
      setState(() {});
    });
    _codeCon.addListener(() {
      if (_phoneCon.text.isNotEmpty && _codeCon.text.isNotEmpty) {
        _btnDisable = false;
      } else {
        _btnDisable = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneCon.dispose();
    _codeCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Icon(
            STIcons.direction_arrowleft,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlankPutKeyborad(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _horFix16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _spaceFix34),
              Text('找回登录密码',
                  style: TextStyle(
                      fontSize: FONTSIZE28, fontWeight: FONTWEIGHT500)),
              SizedBox(height: _spaceFix46),
              PhoneInput(
                areaStr: _selectedArea.values.first,
                onTap: () {
                  final areaCodePage = AreaCodePage(
                    onChanged: (Map<String, String> selected) {
                      setState(() {
                        _selectedArea = selected;
                      });
                    },
                  );
                  STRouters.push(context, areaCodePage);
                },
                controller: _phoneCon,
              ),
              SizedBox(height: _horFix16),
              STInput(
                controller: _codeCon,
                inputType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                suffixIcon: ValidCodeButton(baseStr: '获取验证码'),
              ),
              SizedBox(height: _spaceFix36),
              STButton(
                disabled: _btnDisable,
                text: "下一步",
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: FONTSIZE18,
                    fontWeight: FONTWEIGHT500),
                mainAxisSize: MainAxisSize.max,
                onTap: () {
                  STRouters.push(context, NewPassWordPage());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
