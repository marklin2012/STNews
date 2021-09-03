import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/login/webview_page.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({Key? key}) : super(key: key);

  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late bool _isNews;

  @override
  void initState() {
    super.initState();
    _isNews = true;
  }

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
        title: Text('关于我们'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 52),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '版本号 8.8.08',
                      style: NewsTextStyle.style16NormalSecGrey,
                    ),
                    SizedBox(height: 52),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _isNews = !_isNews;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        height: 48.0,
                        color: Theme.of(context).backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '检测更新',
                              style: NewsTextStyle.style16NormalBlack,
                            ),
                            if (_isNews)
                              Text(
                                '已是最新版本',
                                style: NewsTextStyle.style16NormalSecGrey,
                              ),
                            if (!_isNews)
                              Text(
                                '当前最新版本为8.8.09',
                                style: NewsTextStyle.style16NormalSecGrey,
                              ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        STRouters.push(
                            context,
                            WebViewPage(
                              title: '软件许可及服务协议',
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        height: 48.0,
                        color: Theme.of(context).backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '软件许可及服务协议',
                              style: NewsTextStyle.style16NormalBlack,
                            ),
                            Icon(STIcons.direction_rightoutlined, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '公司名称/版权所有',
                      style: NewsTextStyle.style14NormalFourGrey,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Copyright@2011-2021.Abcdefg All fasle',
                      style: NewsTextStyle.style14NormalFourGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
