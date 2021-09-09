import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class ChangeInfoPage extends StatefulWidget {
  const ChangeInfoPage({Key? key, required this.isChangeSex}) : super(key: key);

  final bool isChangeSex;

  @override
  _ChangeInfoPageState createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends State<ChangeInfoPage> {
  late bool _isChangeSex;
  late String _title;
  TextEditingController? _controller;

  int _originSex = 0;
  int _sex = 0;

  @override
  void initState() {
    super.initState();
    _isChangeSex = widget.isChangeSex;
    _title = _isChangeSex ? '性别' : '昵称';
    if (!_isChangeSex) {
      _controller = TextEditingController();
    }
    _originSex = UserProvider.shared.user.sex ?? 0;
    _sex = _originSex;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            STRouters.pop(context);
          },
        ),
        title: Text(_title),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: STButton(
              type: STButtonType.text,
              text: '保存',
              textStyle: NewsTextStyle.style17NormalBlack,
              onTap: _saveAction,
            ),
          ),
        ],
      ),
      body: _getSubWidget(),
    );
  }

  void _saveAction() {
    if (_isChangeSex) {
      // 修改性别
      if (_originSex == _sex) {
        STToast.show(context: context, message: '未改变性别');
        return;
      }
      Api.updateUserInfo(sex: _sex).then((resultData) {
        if (resultData.success) {
          UserProvider.shared.changeUser(sex: _sex);
          STRouters.pop(context);
        } else {
          STToast.show(context: context, message: resultData.message);
        }
      });
    } else {
      // 修改昵称
      if (_controller!.text.length < 4) {
        STToast.show(context: context, message: '输入的昵称少于4个字符');
        return;
      }
      Api.updateUserInfo(nickname: _controller!.text).then((resultData) {
        if (resultData.success) {
          UserProvider.shared.changeUser(nickname: _controller!.text);
          STRouters.pop(context);
        } else {
          STToast.show(context: context, message: resultData.message);
        }
      });
    }
  }

  Widget _getSubWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 24.0),
        color: Theme.of(context).primaryColor,
        child: _isChangeSex ? _changeSex() : _changeNickName());
  }

  Widget _changeSex() {
    return Column(
      children: [
        _subSexWidget(
            title: '男',
            isSelected: _sex == 1,
            onTap: () {
              setState(() {
                _sex = 1;
              });
            }),
        SizedBox(height: 4.0),
        _subSexWidget(
            title: '女',
            isSelected: _sex == 2,
            onTap: () {
              setState(() {
                _sex = 2;
              });
            }),
      ],
    );
  }

  Widget _subSexWidget({
    String? title,
    void Function()? onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 48.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: NewsTextStyle.style16NormalBlack,
            ),
            if (isSelected) Icon(STIcons.commonly_selected),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _changeNickName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          STInput(
            controller: _controller,
            placeholder: '请设置你的昵称',
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Color(0xFFC4C5C7)),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(STIcons.status_exclamationcircle, size: 14),
              SizedBox(width: 5.0),
              Text(
                '昵称限制4-16个字符',
                style: NewsTextStyle.style14NormalSecGrey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
