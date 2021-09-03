import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/person/person_setting/account_security/change_mobile/new_mobile_page.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

class ChangeMobilePage extends StatelessWidget {
  const ChangeMobilePage({Key? key}) : super(key: key);

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
        title: Text('手机号'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 56),
            Icon(STIcons.newsletter_mobile, size: 44),
            SizedBox(height: 24),
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              String _mobile = userProvider.user.mobile ?? '';
              return Text(
                STString.removeSpaceAndSecurity(_mobile),
                style: NewsTextStyle.style22BoldBlack,
              );
            }),
            SizedBox(height: 52),
            STButton(
              text: '更换',
              textStyle: NewsTextStyle.style18BoldWhite,
              mainAxisSize: MainAxisSize.max,
              radius: 8.0,
              onTap: () {
                STRouters.push(context, NewMobilePage());
              },
            )
          ],
        ),
      ),
    );
  }
}
