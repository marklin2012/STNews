import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/home/model/news_model.dart';
import 'package:stnews/login/model/user_manager.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/st_image.dart';
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
    _getFavouritesData();
  }

  void _getFavouritesData() {
    Api.getFavourite().then((result) {});
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
            child: Consumer<UserManager>(
              builder: (context, userManager, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).accentColor,
                          ),
                          child: STImage.loadingImage(
                              imageUrl: userManager.user.avatar),
                        ),
                        title: Text(
                          userManager.user.nickname ?? '',
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
                            _iconAndText(
                                icon: Icons.favorite,
                                title: (userManager.user.favourites ?? 0)
                                    .toString(),
                                unit: '关注',
                                onTap: () {}),
                            Container(
                              width: 1,
                              height: 28,
                              color: Color(0xFFDFE2E7),
                            ),
                            _iconAndText(
                                icon: Icons.favorite_outline,
                                title: (userManager.user.followers ?? 0)
                                    .toString(),
                                unit: '粉丝',
                                onTap: () {}),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
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

  Widget _iconAndText({
    IconData? icon,
    String? title,
    String? unit,
    void Function()? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 24),
          SizedBox(width: 8.0),
          if (title != null)
            Text(
              title,
              style: TextStyle(fontSize: FONTSIZE16, fontWeight: FONTWEIGHT500),
            ),
          if (unit != null)
            Text(
              unit,
              style: TextStyle(fontSize: FONTSIZE14, fontWeight: FONTWEIGHT400),
            ),
        ],
      ),
    );
  }
}
