import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

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
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
        title: Text('消息设置'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        color: Theme.of(context).backgroundColor,
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
