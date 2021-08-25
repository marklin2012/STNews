import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/st_button/st_button.dart';
import 'package:stnews/utils/st_routers.dart';

class ValidCodeButton extends StatefulWidget {
  const ValidCodeButton({
    Key? key,
    required this.baseStr,
    this.countDownStr = '重新获取',
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: FONTSIZE14,
      fontWeight: FONTWEIGHT400,
    ),
    this.countDown = 10,
  }) : super(key: key);

  final String baseStr;
  final String countDownStr;
  final TextStyle style;
  final int countDown;

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

  void _countDown() {
    _btnDisabled = !_btnDisabled;
    setState(() {});
    _timer?.cancel();
    _timer = null;
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_currentTime != 0) {
        _currentTime--;
        _btnValueNoti!.value =
            widget.countDownStr + "(" + _currentTime.toString() + ")";
      } else {
        _btnValueNoti!.value = widget.baseStr;
        _btnDisabled = !_btnDisabled;
        _timer?.cancel();
        _timer = null;
        _currentTime = widget.countDown;
      }
    });
  }
}
