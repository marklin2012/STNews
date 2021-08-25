import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
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
  late TextEditingController _controller;

  var isSelectedMan = false;

  @override
  void initState() {
    super.initState();
    _isChangeSex = widget.isChangeSex;
    _title = _isChangeSex ? '性别' : '昵称';
    if (!_isChangeSex) {
      _controller = TextEditingController();
    }
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
              textStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
              onTap: _saveAction,
            ),
          ),
        ],
      ),
      body: _getSubWidget(),
    );
  }

  void _saveAction() {}

  Widget _getSubWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 24.0),
        color: Theme.of(context).primaryColor,
        child: _isChangeSex ? _changeSex() : _changeNickName());
  }

  Widget _changeSex() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 48.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '男',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                if (isSelectedMan) Icon(STIcons.commonly_selected),
              ],
            ),
          ),
          onTap: () {
            isSelectedMan = true;
            setState(() {});
          },
        ),
        SizedBox(height: 4.0),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 48,
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '女',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                if (!isSelectedMan) Icon(STIcons.commonly_selected),
              ],
            ),
          ),
          onTap: () {
            isSelectedMan = false;
            setState(() {});
          },
        ),
      ],
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
                style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}
