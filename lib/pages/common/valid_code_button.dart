import 'dart:async';

import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/news_loading.dart';

import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/string+.dart';

class ValidCodeButton extends StatefulWidget {
  const ValidCodeButton({
    Key? key,
    required this.baseStr,
    this.mobile = '',
    this.countDownStr = '秒后重发',
    this.style,
    this.countDown = 30,
  }) : super(key: key);

  final String baseStr;
  final String countDownStr;
  final TextStyle? style;
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
  TextStyle? _textStyle;

  @override
  void initState() {
    super.initState();
    _btnValueNoti = ValueNotifier(widget.baseStr);
    _currentTime = widget.countDown;
    _textStyle = widget.style ?? NewsTextStyle.style14NormalWhite;
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
          textStyle: _textStyle,
          disabled: _btnDisabled,
          onTap: _getCheckCode,
        );
      },
    );
  }

  void _getCheckCode() async {
    if (widget.mobile.isNotEmpty) {
      final _mobile = STString.removeSpace(widget.mobile);
      NewsLoading.start(context);
      // 请求接口
      final result = await Api.getCheckCode(mobile: _mobile);
      NewsLoading.stop();
      if (result.success) {
        _btnDisabled = !_btnDisabled;
        setState(() {});
        _startTimer();
      }
      STMessage.show(context: context, title: '验证码如下', message: '000000');
    } else {
      STMessage.show(context: context, title: '请输入手机号');
    }
  }

  /// 启动Timer计时
  void _startTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_currentTime != 0) {
        _currentTime--;
        _btnValueNoti!.value = _currentTime.toString() + widget.countDownStr;
      } else {
        /// 重置
        _btnValueNoti!.value = widget.baseStr;
        _btnDisabled = !_btnDisabled;
        _timer?.cancel();
        _timer = null;
        _currentTime = widget.countDown;
      }
    });
  }
}
