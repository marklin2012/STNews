import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/login/login_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/news_text_style.dart';

import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

const _horFix16 = 16.0;
const _spaceFix34 = 34.0;
const _spaceFix36 = 36.0;
const _spaceFix46 = 46.0;

class NewPassWordPage extends StatefulWidget {
  const NewPassWordPage({Key? key, required this.mobile}) : super(key: key);

  final String mobile;

  @override
  _NewPassWordPageState createState() => _NewPassWordPageState();
}

class _NewPassWordPageState extends State<NewPassWordPage> {
  var _btnDisable = true;

  TextEditingController _firstCon = TextEditingController();
  TextEditingController _confirmCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstCon.addListener(() {
      if (_firstCon.text.isNotEmpty && _confirmCon.text.isNotEmpty) {
        _btnDisable = false;
      } else {
        _btnDisable = true;
      }
      setState(() {});
    });
    _confirmCon.addListener(() {
      if (_firstCon.text.isNotEmpty && _confirmCon.text.isNotEmpty) {
        _btnDisable = false;
      } else {
        _btnDisable = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstCon.dispose();
    _confirmCon.dispose();
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
            color: ColorConfig.textFirColor,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlankPutKeyborad(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _horFix16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _spaceFix34),
              Text('设置新密码', style: NewsTextStyle.style28BoldBlack),
              SizedBox(height: _spaceFix46),
              STInput.password(
                controller: _firstCon,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              SizedBox(height: _horFix16),
              STInput.password(
                controller: _confirmCon,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              SizedBox(height: _spaceFix36),
              STButton(
                disabled: _btnDisable,
                text: "确定",
                textStyle: NewsTextStyle.style18BoldWhite,
                mainAxisSize: MainAxisSize.max,
                onTap: _sureAction,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sureAction() async {
    if (_firstCon.text.isEmpty) {
      STToast.show(context: context, message: '请输入密码');
      return;
    } else if (_confirmCon.text.isEmpty) {
      STToast.show(context: context, message: '请输入确认密码');
      return;
    } else if (_firstCon.text != _confirmCon.text) {
      STToast.show(context: context, message: '两次密码输入不一致');
      return;
    }
    NewsLoading.start(context);
    ResultData result = await Api.setNewPassword(
        mobile: STString.removeSpace(widget.mobile), password: _firstCon.text);
    if (result.success) {
      STToast.show(context: context, message: '设置密码成功');
      Navigator.of(context).popUntil(ModalRoute.withName(LoginPage.routeName));
    }
    NewsLoading.stop();
  }
}
