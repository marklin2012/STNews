import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonNotiPage extends StatefulWidget {
  const PersonNotiPage({Key? key}) : super(key: key);

  @override
  _PersonNotiPageState createState() => _PersonNotiPageState();
}

class _PersonNotiPageState extends State<PersonNotiPage> {
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
        title: Text('消息中心'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: STButton(
              type: STButtonType.text,
              text: '清除未读',
              textStyle:
                  TextStyle(fontSize: FONTSIZE17, fontWeight: FONTWEIGHT400),
              onTap: _deletUnRead,
            ),
          ),
        ],
      ),
    );
  }

  void _deletUnRead() {}
}
