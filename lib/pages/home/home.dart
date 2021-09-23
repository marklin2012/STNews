import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/pages/home/search_post_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const _finalPerPage = 5;

class _HomePageState extends State<HomePage> {
  List<PostModel> _lists = [];
  late int _page;
  late int _perpage;
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();

    _page = 1;
    _perpage = _finalPerPage;
    _loadAndRefresh(true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
            tag: SearchPostPage.searchHeroTag,
            child: STButton.icon(
                backgroundColor: Colors.transparent,
                icon: Icon(STIcons.commonly_search),
                onTap: () {
                  STRouters.push(context, SearchPostPage());
                })),
        title: Text('资讯'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_lists.isEmpty) {
      return EmptyViewWidget(
        content: '内容加载失败,请点击重试',
        onTap: () {},
      );
    }
    return NewsEasyRefresh(
      hasHeader: true,
      hasFooter: true,
      onRefresh: () async {
        _loadAndRefresh(false);
      },
      onLoad: _loadMore,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PageViewWidget(
              pageList: ["#babber1#", "#babber2#", "#babber3#"],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final _model = _lists[index];
                return Container(
                  height: 92,
                  child: ListTile(
                    title: Text(_model.title ?? ''),
                    subtitle: Text(_model.author?.nickname ?? ''),
                    trailing: Container(
                      width: 102,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                    ),
                    onTap: () {
                      _gotoDetailPage(index);
                    },
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

  void _gotoDetailPage(int index) {
    STRouters.push(
      context,
      PostDetailPage(
        model: _lists[index],
      ),
    );
  }

  Future _loadAndRefresh(bool isFirst) async {
    _page = 1;
    _perpage = _finalPerPage;
    if (!isFirst) NewsLoading.start(context);
    Api.getPosts(page: _page, perpage: _perpage).then((result) {
      if (result.success) {
        List _data = result.data as List;
        _hasMore = _data.isNotEmpty;
        _lists = _data.map((e) => PostModel.fromJson(e)).toList();
        setState(() {});
      }
      if (!isFirst) {
        NewsLoading.stop();
        EasySnackbar.show(
          context: context,
          backgroundColor: Color(0xFFA6C4FF),
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 56),
          padding: EdgeInsets.symmetric(vertical: 5),
          title: Container(
            alignment: Alignment.center,
            child: Text(
              '为您推荐$_perpage条内容',
              style: NewsTextStyle.style14NormalWhite,
            ),
          ),
        );
      }
    });
  }

  Future _loadMore() async {
    if (_hasMore) {
      _page++;
      NewsLoading.start(context);
      Api.getPosts(page: _page, perpage: _perpage).then((result) {
        NewsLoading.stop();
        if (result.success) {
          List _data = result.data as List;
          _hasMore = _data.isNotEmpty;
          for (Map<String, dynamic> item in _data) {
            final _temp = PostModel.fromJson(item);
            _lists.add(_temp);
          }
          setState(() {});
        }
      });
    }
  }
}
