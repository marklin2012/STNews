import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/pages/common/valid_code_button.dart';

class NewMobileCodePage extends StatefulWidget {
  const NewMobileCodePage({Key? key}) : super(key: key);

  @override
  _NewMobileCodePageState createState() => _NewMobileCodePageState();
}

class _NewMobileCodePageState extends State<NewMobileCodePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
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
        title: Text('验证码'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              '验证码已发送到 187******68',
              style: TextStyle(fontSize: FONTSIZE16, fontWeight: FONTWEIGHT400),
            ),
            SizedBox(height: 18.0),
            STInput(
              controller: _controller,
              inputType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              suffixIcon: ValidCodeButton(baseStr: '获取验证码'),
            ),
            SizedBox(height: 68.0),
            STButton(
              text: '确定',
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: FONTSIZE18,
                fontWeight: FONTWEIGHT500,
              ),
              mainAxisSize: MainAxisSize.max,
              onTap: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName('/account_security'));
                STToast.show(
                  context: context,
                  isIconTop: true,
                  icon: Icon(
                    STIcons.commonly_selected,
                    color: Theme.of(context).primaryColor,
                    size: 34,
                  ),
                  message: '手机号更换成功',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
