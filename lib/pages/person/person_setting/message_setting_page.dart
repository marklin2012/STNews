import 'package:flutter/material.dart';

import 'package:saturn/saturn.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

// ignore: must_be_immutable
class MessageSettingPage extends StatelessWidget {
  MessageSettingPage({Key? key}) : super(key: key);

  late bool _isOpen;
  late ValueNotifier<bool> _notifier;

  void init() {
    _isOpen = false;
    _notifier = ValueNotifier(_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        leading: NewsPopBtn.popBtn(context),
        title: Text('消息设置'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '推送通知',
              style: NewsTextStyle.style16NormalBlack,
            ),
            ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (BuildContext context, bool value, wiedgt) {
                  return STSwitch(
                    value: value,
                    onChanged: (bool value) {
                      _notifier.value = value;
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
