import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonLikePage extends StatelessWidget {
  const PersonLikePage({Key? key}) : super(key: key);

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
        title: Text('我的关注'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemExtent: 56,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '用户昵称',
                          style: TextStyle(
                            fontSize: FONTSIZE16,
                            fontWeight: FONTWEIGHT400,
                          ),
                        ),
                      ],
                    ),
                    STButton(
                      type: STButtonType.outline,
                      text: '已关注',
                      borderColor: Color(0xFF888888),
                      textStyle: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: FONTSIZE16,
                          fontWeight: FONTWEIGHT400),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
