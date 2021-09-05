import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class SearchPostPage extends StatefulWidget {
  static const searchHeroTag = 'searchPost';
  const SearchPostPage({Key? key}) : super(key: key);

  @override
  _SearchPostPageState createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  late TextEditingController _controller;
  late List<PostModel> _lists;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _lists = [
      PostModel(id: '0', title: 'title0', author: 'author0', image: 'image0'),
      PostModel(id: '1', title: 'title1', author: 'author1', image: 'image1'),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 32 - 30 - 8,
                      height: 44,
                      child: STInput(
                        prefixIcon: Hero(
                          tag: SearchPostPage.searchHeroTag,
                          child: Icon(STIcons.commonly_search),
                        ),
                        placeholder: '请输入搜索内容',
                        controller: _controller,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      width: 30,
                      child: STButton(
                        text: '取消',
                        textStyle: NewsTextStyle.style12NormalThrGrey,
                        type: STButtonType.text,
                        backgroundColor: Colors.transparent,
                        onTap: () {
                          STRouters.pop(context);
                        },
                      ),
                    ),
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
      ),
    );
  }
}
