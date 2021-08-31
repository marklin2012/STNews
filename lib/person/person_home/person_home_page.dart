import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/home/model/news_model.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonHomePage extends StatefulWidget {
  const PersonHomePage({Key? key}) : super(key: key);

  @override
  _PersonHomePageState createState() => _PersonHomePageState();
}

class _PersonHomePageState extends State<PersonHomePage> {
  late List<NewsModel> _lists;

  @override
  void initState() {
    super.initState();
    _lists = [
      NewsModel(id: '0', title: 'title0', author: 'author0', image: 'image0'),
      NewsModel(id: '1', title: 'title1', author: 'author1', image: 'image1'),
      NewsModel(id: '2', title: 'title2', author: 'author2', image: 'image2'),
      NewsModel(id: '3', title: 'title3', author: 'author3', image: 'image3'),
      NewsModel(id: '4', title: 'title4', author: 'author4', image: 'image4'),
    ];
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        // 去头像设置
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    title: Text(
                      '用户123456',
                      style: TextStyle(
                          fontSize: FONTSIZE18, fontWeight: FONTWEIGHT500),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _iconAndText(Icons.favorite, '99', '关注'),
                        Container(
                          width: 1,
                          height: 28,
                          color: Color(0xFFDFE2E7),
                        ),
                        _iconAndText(Icons.favorite_outline, '1399', '粉丝'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final _model = _lists[index];
                return Container(
                  height: 92,
                  child: ListTile(
                    title: Text(_model.title!),
                    subtitle: Text(_model.author!),
                    trailing: Container(
                      width: 102,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
              childCount: _lists.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconAndText(IconData icon, String title, String unit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(fontSize: FONTSIZE16, fontWeight: FONTWEIGHT500),
        ),
        Text(
          unit,
          style: TextStyle(fontSize: FONTSIZE14, fontWeight: FONTWEIGHT400),
        ),
      ],
    );
  }
}
