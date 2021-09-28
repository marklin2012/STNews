import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';
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

  late bool _isSearched;

  List<PostModel> _lists = [];

  bool get isEmpty => _lists.isEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isSearched = false;
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
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 44,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    child: STButton.icon(
                      backgroundColor: Colors.transparent,
                      size: STButtonSize.small,
                      icon: Icon(
                        STIcons.direction_leftoutlined,
                        color: ColorConfig.textFirColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 36 - 8 - 48 - 8,
                    height: 32,
                    child: STInput(
                      padding: EdgeInsets.zero,
                      prefixIcon: Hero(
                        tag: SearchPostPage.searchHeroTag,
                        child: Icon(STIcons.commonly_search),
                      ),
                      decoration: BoxDecoration(
                        color: ColorConfig.fourGrey,
                        borderRadius: BorderRadius.circular(4.0),
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
                        _isSearched = true;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 44,
              bottom: 0,
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (!_isSearched) {
      return Container();
    }
    if (isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: EmptyViewWidget(
          fixTop: 60,
          content: '暂无搜索内容',
        ),
      );
    } else {
      return ListView.builder(
          itemCount: _lists.length,
          itemBuilder: (context, index) {
            final _model = _lists[index];
            return Container(
              height: 92,
              child: ListTile(
                title: NewsRichText(
                  textContent: _model.title,
                  searchContent: _controller.text,
                ),
                subtitle: Text(_model.author?.nickname ?? ''),
                trailing: Container(
                  width: 102,
                  height: 76,
                  decoration: BoxDecoration(
                    color: ColorConfig.accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                ),
                onTap: () {},
              ),
            );
          });
    }
  }
}
