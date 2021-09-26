import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/login/area_code_page.dart';
import 'package:stnews/pages/login/find_password_page.dart';
import 'package:stnews/pages/login/phone_input.dart';
import 'package:stnews/pages/tabbar.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

const _topFix = 88.0;
const _horFix16 = 16.0;
const _spaceFix36 = 36.0;
const _spaceFix44 = 44.0;

class PasswordLoginWidget extends StatefulWidget {
  const PasswordLoginWidget({Key? key, this.switchCodeTap}) : super(key: key);

  final Function(bool)? switchCodeTap;

  @override
  _PasswordLoginWidgetState createState() => _PasswordLoginWidgetState();
}

class _PasswordLoginWidgetState extends State<PasswordLoginWidget> {
  var _loginDisable = true;
  var _selectedArea = {"中国": "86"};
  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _passwordCon = TextEditingController();
  late ValueNotifier<bool> _btnNotifier;

  @override
  void initState() {
    super.initState();
    var _loading = false;
    _btnNotifier = ValueNotifier(_loading);
    _phoneCon.addListener(() {
      if (_phoneCon.text.length > 7 && _passwordCon.text.isNotEmpty) {
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
    _passwordCon.dispose();
    _btnNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: _topFix),
          _buildTitle(),
          SizedBox(height: _spaceFix44),
          _buildForm(),
          SizedBox(height: _spaceFix36),
          ValueListenableBuilder(
            valueListenable: _btnNotifier,
            builder: (context, bool loading, child) {
              return STButton(
                mainAxisSize: MainAxisSize.max,
                text: '登录',
                textStyle: NewsTextStyle.style18BoldWhite,
                disabled: _loginDisable,
                loading: loading,
                onTap: () {
                  _requestHttp();
                },
              );
            },
          ),
          SizedBox(height: _horFix16),
          STButton(
            text: '忘记密码',
            type: STButtonType.text,
            textStyle: NewsTextStyle.style16NormalBlack,
            onTap: () {
              STRouters.push(context, FindPasswordPage());
            },
          )
        ],
      ),
    );
  }

  void _requestHttp() async {
    _btnNotifier.value = true;
    ResultData _resultData = await Api.loginWithPassword(
        mobile: STString.removeSpace(_phoneCon.text),
        password: _passwordCon.text);
    if (_resultData.success) {
      final token = _resultData.data['token'];
      Map<String, dynamic> user = _resultData.data['user'];
      UserProvider.shared.setToken(token);
      UserProvider.shared.user = UserModel.fromJson(user);
      STRouters.push(context, TabbarPage());
    }
    _btnNotifier.value = false;
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '手机密码登录',
          style: NewsTextStyle.style28BoldBlack,
        ),
        STButton(
          type: STButtonType.text,
          text: '验证码登录',
          onTap: () {
            if (widget.switchCodeTap != null) {
              widget.switchCodeTap!(false);
            }
          },
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
        STInput.password(
          key: Key('password'),
          controller: _passwordCon,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
        ),
      ],
    );
  }
}
