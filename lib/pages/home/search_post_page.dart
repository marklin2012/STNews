import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_home_cell.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/news_rich_text.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/providers/post_search_provider.dart';
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

  late bool _isSearched;

  PostSearchProvider get postSearchProvider =>
      Provider.of<PostSearchProvider>(context, listen: false);

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
      body: BlankPutKeyborad(
        child: Container(
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
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 13.0),
                        child: Icon(
                          STIcons.direction_leftoutlined,
                          color: ColorConfig.textFirColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: STInput(
                        height: 32.0,
                        padding: EdgeInsets.zero,
                        cursorHeight: 24.0,
                        contentPadding: EdgeInsets.only(bottom: 18.0),
                        prefixIcon: Hero(
                          tag: SearchPostPage.searchHeroTag,
                          child: Icon(
                            STIcons.commonly_search,
                            color: ColorConfig.textFourColor,
                            size: 20.0,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: ColorConfig.fourGrey,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        placeholder: '请输入搜索内容',
                        controller: _controller,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: STButton(
                        text: '搜索',
                        textStyle: NewsTextStyle.style17NormalFirBlue,
                        type: STButtonType.text,
                        backgroundColor: Colors.transparent,
                        onTap: _search,
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
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<PostSearchProvider>(builder: (context, searchProvider, _) {
      if (!_isSearched) {
        return Container();
      }
      if (searchProvider.isEmpty) {
        return Container(
          alignment: Alignment.center,
          child: EmptyViewWidget(
            fixTop: 60,
            content: '暂无搜索内容',
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: searchProvider.posts.length,
              itemBuilder: (context, index) {
                final _model = searchProvider.posts[index];
                return NewsHomeCell(
                  title: NewsRichText(
                    textContent: _model.title,
                    searchContent: _controller.text,
                  ),
                  subTitle: Text(
                    _model.author?.nickname ?? '',
                    style: NewsTextStyle.style12NormalThrGrey,
                  ),
                  trailing: CachedNetworkImage(
                    imageUrl: _model.coverImage ??
                        'http://via.placeholder.com/102x76',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                      height: 76,
                      width: 102,
                    ),
                  ),
                  onTap: () {
                    _gotoDetailPage(index);
                  },
                );
              }),
        );
      }
    });
  }

  /// 点击搜素
  void _search() {
    if (_controller.text.isEmpty || _controller.text.length == 0) {
      STToast.show(context: context, message: '搜素内容不能为空');
      return;
    }
    STDebounce().debounce(() async {
      NewsLoading.start(context);
      _isSearched = true;
      await postSearchProvider.search(key: _controller.text);
      NewsLoading.stop();
    }, 500);
  }

  void _gotoDetailPage(int index) {
    STRouters.push(
      context,
      PostDetailPage(
        model: postSearchProvider.posts[index],
      ),
    );
  }
}
