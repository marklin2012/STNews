import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/valid_code_button.dart';
import 'package:stnews/pages/login/area_code_page.dart';
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
const _spaceFix24 = 24.0;
const _spaceFix36 = 36.0;

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

  @override
  void initState() {
    super.initState();
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
          SizedBox(height: _spaceFix24),
          _buildForm(),
          SizedBox(height: _spaceFix36),
          STButton(
            mainAxisSize: MainAxisSize.max,
            text: '登录',
            textStyle: NewsTextStyle.style18BoldWhite,
            disabled: _loginDisable,
            onTap: () {
              _requestHttp();
            },
          ),
        ],
      ),
    );
  }

  void _requestHttp() async {
    /// pin固定为：'000000'
    ResultData _resultData = await Api.loginWithPin(
      mobile: STString.removeSpace(_phoneCon.text),
      pin: _codeCon.text,
    );
    if (_resultData.success) {
      final token = _resultData.data['token'];
      Map<String, dynamic> user = _resultData.data['user'];
      UserProvider.shared.setToken(token);
      UserProvider.shared.user = UserModel.fromJson(user);
      STRouters.push(context, TabbarPage());
    } else {
      STToast.show(context: context, message: _resultData.message);
    }
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
          key: Key('code'),
          controller: _codeCon,
          inputType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          suffixIcon: ValidCodeButton(
            baseStr: '获取验证码',
            mobile: _phoneCon.text,
          ),
        ),
      ],
    );
  }
}
