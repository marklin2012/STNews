import 'dart:async';

import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/service/api.dart';
import 'package:stnews/utils/st_routers.dart';

class ValidCodeButton extends StatefulWidget {
  const ValidCodeButton({
    Key? key,
    required this.baseStr,
    this.mobile = '12345677123',
    this.countDownStr = '秒后重发',
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: FONTSIZE14,
      fontWeight: FONTWEIGHT400,
    ),
    this.countDown = 30,
  }) : super(key: key);

  final String baseStr;
  final String countDownStr;
  final TextStyle style;
  final int countDown;
  final String mobile;

  @override
  _ValidCodeButtonState createState() => _ValidCodeButtonState();
}

class _ValidCodeButtonState extends State<ValidCodeButton> {
  ValueNotifier<String>? _btnValueNoti;
  bool _btnDisabled = false;
  Timer? _timer;
  int _currentTime = 0;

  @override
  void initState() {
    super.initState();
    _btnValueNoti = ValueNotifier(widget.baseStr);
    _currentTime = widget.countDown;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _btnValueNoti?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _btnValueNoti!,
      builder: (context, String value, child) {
        return STButton(
          text: value,
          textStyle: widget.style,
          disabled: _btnDisabled,
          onTap: _countDown,
        );
      },
    );
  }

  void _countDown() async {
    final _mobile = widget.mobile.replaceAll(' ', '');
    final result = await Api.getCheckCode(mobile: _mobile);
    if (result.success) {
      _btnDisabled = !_btnDisabled;
      setState(() {});
      _timer?.cancel();
      _timer = null;
      _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        if (_currentTime != 0) {
          _currentTime--;
          _btnValueNoti!.value = _currentTime.toString() + widget.countDownStr;
        } else {
          _btnValueNoti!.value = widget.baseStr;
          _btnDisabled = !_btnDisabled;
          _timer?.cancel();
          _timer = null;
          _currentTime = widget.countDown;
        }
      });
    } else {
      STToast.show(context: context, message: result.message);
    }
  }
}
