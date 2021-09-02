import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/st_routers.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key}) : super(key: key);

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  late TextEditingController _originCon;
  late TextEditingController _newCon;
  late TextEditingController _confirmCon;

  @override
  void initState() {
    super.initState();
    _originCon = TextEditingController();
    _newCon = TextEditingController();
    _confirmCon = TextEditingController();
  }

  @override
  void dispose() {
    _originCon.dispose();
    _newCon.dispose();
    _confirmCon.dispose();
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
        title: Text('登录密码'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 32.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            STInput.password(
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text('原密码'),
                  )
                ],
              ),
              placeholder: '请输入原密码',
              controller: _originCon,
            ),
            SizedBox(height: 12),
            STInput.password(
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text('新密码'),
                  )
                ],
              ),
              placeholder: '请输入新密码',
              controller: _newCon,
            ),
            SizedBox(height: 12),
            STInput.password(
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text('确认密码'),
                  )
                ],
              ),
              placeholder: '请输入新密码',
              controller: _confirmCon,
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '密码必须是8-16位数字、字母、符号的组合',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: FONTSIZE14,
                fontWeight: FONTWEIGHT400,
              ),
            ),
            SizedBox(height: 68),
            STButton(
              text: '完成',
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: FONTSIZE18,
                fontWeight: FONTWEIGHT500,
              ),
              radius: 8.0,
              mainAxisSize: MainAxisSize.max,
              onTap: _changePassword,
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    if (_newCon.text.isEmpty) {
      STToast.show(context: context, message: '请输入新密码');
    } else if (_confirmCon.text.isEmpty) {
      STToast.show(context: context, message: '请确认密码');
    } else if (_newCon.text != _confirmCon.text) {
      STToast.show(context: context, message: '两次密码输入不一致');
    } else {
      Api.setPassword(_newCon.text).then((reslutData) {
        if (reslutData.success) {
          debugPrint('密码修改成功');
          STRouters.pop(context);
        }
      });
    }
  }
}
