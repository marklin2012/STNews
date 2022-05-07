import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/login/login_widget/code_login_widget.dart';
import 'package:stnews/pages/login/login_widget/password_login_widget.dart';
import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/utils/blank_put_keyborad.dart';

import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

const _bottomFix = 52.0;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlankPutKeyborad(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: _screenWidth,
                    child: CodeLoginWidget(
                      switchPasswordTap: (bool value) {
                        _scrollController.animateTo(_screenWidth,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: PasswordLoginWidget(
                      switchCodeTap: (bool value) {
                        _scrollController.animateTo(0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: _bottomFix),
              child: _buildBottom(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '登录即代表同意',
          style: NewsTextStyle.style12NormalThrGrey,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '用户协议',
            textStyle: NewsTextStyle.style12NormalBlack,
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
          style: NewsTextStyle.style12NormalThrGrey,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '隐私政策',
            textStyle: NewsTextStyle.style12NormalBlack,
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
}
