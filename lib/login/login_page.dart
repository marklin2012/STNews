import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/login/area_code_page.dart';
import 'package:stnews/login/find_password_page.dart';
import 'package:stnews/login/model/user_manager.dart';
import 'package:stnews/login/model/user_model.dart';
import 'package:stnews/login/phone_input.dart';
import 'package:stnews/login/webview_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/sharedpreferences/shared_pref.dart';
import 'package:stnews/tabbar/tabbar.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/valid_code_button.dart';

const _topFix = 122.0;
const _bottomFix = 52.0;
const _horFix16 = 16.0;
const _spaceFix24 = 24.0;
const _spaceFix36 = 36.0;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isCodeLogin = true;
  var _loginDisable = true;
  var _selectedArea = {"中国": "86"};

  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _codeCon = TextEditingController();
  TextEditingController _passwordCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneCon.addListener(() {
      if ((_phoneCon.text.length > 7 && _codeCon.text.length == 6) ||
          (_phoneCon.text.length > 7 && _passwordCon.text.isNotEmpty)) {
        _loginDisable = false;
      } else {
        _loginDisable = true;
      }
      setState(() {});
    });
    _codeCon.addListener(() {
      if (_phoneCon.text.length > 7 && _codeCon.text.length == 6) {
        _loginDisable = false;
      } else {
        _loginDisable = true;
      }
      setState(() {});
    });
    _passwordCon.addListener(() {
      if (_phoneCon.text.length > 7 && _passwordCon.text.isNotEmpty) {
        _loginDisable = false;
      } else {
        _loginDisable = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneCon.dispose();
    _codeCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPutKeyborad(
        child: Container(
          padding: const EdgeInsets.only(
              top: _topFix,
              bottom: _bottomFix,
              left: _horFix16,
              right: _horFix16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildTitle(),
                  SizedBox(height: _spaceFix24),
                  _buildForm(),
                  SizedBox(height: _spaceFix36),
                  STButton(
                    mainAxisSize: MainAxisSize.max,
                    text: '登录',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: FONTSIZE18,
                        fontWeight: FONTWEIGHT500),
                    disabled: _loginDisable,
                    onTap: _loginAction,
                  ),
                  if (!_isCodeLogin) SizedBox(height: _horFix16),
                  if (!_isCodeLogin)
                    STButton(
                      text: '忘记密码',
                      type: STButtonType.text,
                      textStyle: TextStyle(
                          fontSize: FONTSIZE16, fontWeight: FONTWEIGHT400),
                      onTap: () {
                        STRouters.push(context, FindPasswordPage());
                      },
                    )
                ],
              ),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAction() {
    _requestHttp();
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_isCodeLogin ? '手机验证码登录' : '手机密码登录',
                style:
                    TextStyle(fontSize: FONTSIZE28, fontWeight: FONTWEIGHT500)),
            STButton(
              type: STButtonType.text,
              text: _isCodeLogin ? '密码登录' : '验证码登录',
              onTap: () {
                _isCodeLogin = !_isCodeLogin;
                setState(() {});
              },
            ),
          ],
        ),
        if (_isCodeLogin)
          Text(
            '首次登录即自动注册',
            style: TextStyle(
                color: Color(0xff888888),
                fontSize: FONTSIZE14,
                fontWeight: FONTWEIGHT400),
          ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
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
        if (_isCodeLogin)
          STInput(
            key: Key('code'),
            controller: _codeCon,
            inputType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(6)],
            suffixIcon: ValidCodeButton(
              baseStr: '获取验证码',
              mobile: _phoneCon.text,
            ),
          ),
        if (!_isCodeLogin)
          STInput.password(
            key: Key('password'),
            controller: _passwordCon,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
          ),
      ],
    );
  }

  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '登录即代表同意',
          style: TextStyle(fontSize: FONTSIZE12, color: Color(0xff888888)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '用户协议',
            textStyle: TextStyle(
                fontSize: FONTSIZE12,
                color: Colors.black,
                fontWeight: FONTWEIGHT400),
            onTap: () {
              STRouters.push(
                context,
                WebViewPage(
                  title: '用户协议',
                ),
              );
            },
          ),
        ),
        Text(
          '和',
          style: TextStyle(fontSize: FONTSIZE12, color: Color(0xff888888)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '隐私政策',
            textStyle: TextStyle(
                fontSize: FONTSIZE12,
                color: Colors.black,
                fontWeight: FONTWEIGHT400),
            onTap: () {
              STRouters.push(
                context,
                WebViewPage(
                  title: '隐私政策',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _requestHttp() async {
    ResultData _resultData;
    if (_isCodeLogin) {
      /// pin固定为：'000000'
      _resultData =
          await Api.loginWithPin(mobile: _phoneCon.text, pin: _codeCon.text);
    } else {
      _resultData = await Api.loginWithPassword(
          mobile: _phoneCon.text, password: _passwordCon.text);
    }
    if (_resultData.success) {
      final token = _resultData.data['token'];
      Map<String, dynamic> user = _resultData.data['user'];
      SharedPref.saveToken(token).then((_) {
        SharedPref.saveUsers(user).then((_) {
          UserManager.shared!.user = UserModel.fromJson(user);
          STRouters.push(context, TabbarPage());
        });
      });
    } else {
      STToast.show(context: context, message: _resultData.message);
    }
  }
}
