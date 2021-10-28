import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:stnews/pages/circle/search_circle_page.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_home_cell.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/news_rich_text.dart';
import 'package:stnews/pages/common/news_search_header.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/providers/post_search_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class SearchPostPage extends StatefulWidget {
  static const searchHeroTag = 'searchPost';
  static const searchPostDebounceKey = '_searchPostDebounceKey';
  const SearchPostPage({Key? key}) : super(key: key);

  @override
  _SearchPostPageState createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  late bool _isSearched;
  String _searchValue = '';

  PostSearchProvider get postSearchProvider =>
      Provider.of<PostSearchProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _isSearched = false;
  }

  @override
  void dispose() {
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
                child: NewsSearchHeader(
                  heroTag: SearchPostPage.searchHeroTag,
                  debounceKey: SearchCirclePage.searchCircleDebounceKey,
                  searchTap: (String value) {
                    _search(value);
                  },
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
                    maxLines: 2,
                    textContent: _model.title,
                    searchContent: _searchValue,
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

  /// 点击搜索
  void _search(String value) async {
    _searchValue = value;
    _isSearched = true;
    NewsLoading.start(context);
    await postSearchProvider.search(key: value);
    NewsLoading.stop();
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
