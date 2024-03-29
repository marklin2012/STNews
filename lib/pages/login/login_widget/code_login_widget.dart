import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_toast.dart';
import 'package:stnews/pages/common/token_invalid.dart';
import 'package:stnews/pages/common/valid_code_button.dart';
import 'package:stnews/pages/login/area_code_page.dart';
import 'package:stnews/pages/login/login_widget/login_constant.dart';
import 'package:stnews/pages/login/phone_input.dart';
import 'package:stnews/pages/tabbar.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

class CodeLoginWidget extends StatefulWidget {
  const CodeLoginWidget({Key? key, this.switchPasswordTap}) : super(key: key);

  final Function(bool)? switchPasswordTap;

  @override
  _CodeLoginWidgetState createState() => _CodeLoginWidgetState();
}

class _CodeLoginWidgetState extends State<CodeLoginWidget> {
  var _loginDisable = true;
  var _selectedArea = {"中国": "86"};
  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _codeCon = TextEditingController();
  late ValueNotifier<bool> _btnNotifier;
  int _limitLength = 11;
  FocusNode _phoneNode = FocusNode(debugLabel: 'phone');
  FocusNode _codeNode = FocusNode(debugLabel: 'code');

  @override
  void initState() {
    super.initState();
    var _loading = false;
    _btnNotifier = ValueNotifier(_loading);
    _phoneCon.addListener(() {
      if (_phoneCon.text.length > 7 && _codeCon.text.length == 6) {
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
  }

  @override
  void dispose() {
    _phoneCon.dispose();
    _codeCon.dispose();
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
          SizedBox(height: NewsLoginConstant.topFix),
          _buildTitle(),
          SizedBox(height: NewsLoginConstant.spaceFix24),
          _buildForm(),
          SizedBox(height: NewsLoginConstant.spaceFix36),
          ValueListenableBuilder(
            valueListenable: _btnNotifier,
            builder: (context, bool loading, child) {
              return STButton(
                mainAxisSize: MainAxisSize.max,
                text: '登录',
                textStyle: NewsTextStyle.style18BoldWhite,
                backgroundColor: ColorConfig.baseFirBule,
                disabled: _loginDisable,
                loading: loading,
                height: NewsLoginConstant.loginBtnH,
                onTap: () {
                  _requestHttp();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _requestHttp() async {
    _btnNotifier.value = true;

    /// pin固定为：'000000'
    ResultData _resultData = await Api.loginWithPin(
      mobile: STString.removeSpace(_phoneCon.text),
      pin: _codeCon.text,
    );
    if (_resultData.success) {
      final token = _resultData.data['token'];
      UserProvider.shared.setToken(token);
      Map<String, dynamic> user = _resultData.data['user'];
      UserModel _userM = UserModel.fromJson(user);
      UserProvider.shared.getUserInfo(userID: _userM.id);
      TokenInvalid.resetInvalidCount();
      STRouters.pushReplace(context, TabbarPage.routeName);
    }
    _btnNotifier.value = false;
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '手机验证码登录',
              style: NewsTextStyle.style28BoldBlack,
            ),
            STButton(
              type: STButtonType.text,
              text: '密码登录',
              onTap: () {
                /// 切换登陆方式
                if (widget.switchPasswordTap != null) {
                  widget.switchPasswordTap!(true);
                }
              },
            ),
          ],
        ),
        Text(
          '首次登录即自动注册',
          style: NewsTextStyle.style14NormalThrGrey,
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
                _switchAreaCode(selected);
              },
            );
            STRouters.push(context, areaCodePage);
          },
          controller: _phoneCon,
          focusNode: _phoneNode,
          phoneLength: _limitLength,
          onChanged: (String value) {
            if (value.length == _limitLength) {
              if (!_checkPhoneNumber(value)) return;
              Future.delayed(Duration(milliseconds: 50), () {
                FocusScope.of(context).requestFocus(_codeNode);
              });
            }
          },
        ),
        SizedBox(height: NewsLoginConstant.horFix16),
        STInput(
          key: Key('code'),
          controller: _codeCon,
          focusNode: _codeNode,
          inputType: TextInputType.number,
          textStyle: NewsTextStyle.style16NormalBlack,
          backgoundColor: ColorConfig.primaryColor,
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          suffixIcon: ValidCodeButton(
            baseStr: '获取验证码',
            mobile: _phoneCon.text,
          ),
          placeholder: '输入验证码',
          onChanged: (value) {
            if (value.length == 6) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
        ),
      ],
    );
  }

  Future _switchAreaCode(Map<String, String> selected) async {
    _selectedArea = selected;
    final _selectedKey = _selectedArea.keys.first;
    final lengthValue = await DefaultAssetBundle.of(context)
        .loadString('assets/json/worldcodelength.json');
    final _temps = json.decode(lengthValue);
    _limitLength = int.tryParse(_temps[_selectedKey]) ?? 11;
    setState(() {});
  }

  bool _checkPhoneNumber(String value) {
    if (!NewsLoginConstant.checkPhoneNumber(
      value: value,
      area: _selectedArea.values.first,
    )) {
      Newstoast.showToast(msg: '手机号输入错误');
      return false;
    }
    return true;
  }
}
