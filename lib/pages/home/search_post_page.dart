import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_rich_text.dart';
import 'package:stnews/utils/news_text_style.dart';

class SearchPostPage extends StatefulWidget {
  static const searchHeroTag = 'searchPost';
  const SearchPostPage({Key? key}) : super(key: key);

  @override
  _SearchPostPageState createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  late TextEditingController _controller;
  List<PostModel> _lists = [];

  bool get isEmpty => _lists.isEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // _lists = [
    //   PostModel(id: '0', title: 'title0', author: 'author0', image: 'image0'),
    //   PostModel(id: '1', title: 'title1', author: 'author1', image: 'image1'),
    // ];
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
              child: Row(
                children: [
                  STButton.icon(
                    backgroundColor: Colors.transparent,
                    icon: Icon(
                      STIcons.direction_leftoutlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    width:
                        MediaQuery.of(context).size.width - 36 - 30 - 24 - 12,
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
                    width: 36,
                    child: STButton(
                      text: '搜索',
                      textStyle: NewsTextStyle.style17NormalFirBlue,
                      type: STButtonType.text,
                      backgroundColor: Colors.transparent,
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isEmpty)
              SliverToBoxAdapter(
                child: EmptyViewWidget(
                  spaceH: 60,
                  content: '暂无搜索内容',
                ),
              ),
            if (!isEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final _model = _lists[index];
                    return Container(
                      height: 92,
                      child: ListTile(
                        title: NewsRichText(
                          textContent: _model.title,
                          searchContent: _controller.text,
                        ),
                        subtitle: Text(_model.author!),
                        trailing: Container(
                          width: 102,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0)),
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
