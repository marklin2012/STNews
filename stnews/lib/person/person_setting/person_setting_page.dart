import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonSetingPage extends StatelessWidget {
  const PersonSetingPage({Key? key}) : super(key: key);

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
        title: Text('设置'),
      ),
    );
  }
}
