import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/pages/home/search_post_page.dart';
import 'package:stnews/providers/home_post_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePostProvider get homePostProvider => Provider.of(context, listen: false);

  @override
  void initState() {
    super.initState();
    homePostProvider.initOrRefresh();
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
        title: Text(
          '资讯',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Consumer<HomePostProvider>(builder: (context, homePostP, _) {
      if (homePostP.isEmptyPosts) {
        return EmptyViewWidget(
          content: '暂无数据，点击重新加载',
          onTap: _loadAndRefresh,
        );
      }
      return NewsEasyRefresh(
        hasHeader: true,
        hasFooter: true,
        onRefresh: _loadAndRefresh,
        onLoad: _loadMore,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageViewWidget(
                pageList: homePostP.banners,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final _model = homePostP.posts[index];
                  return Container(
                    height: 92,
                    child: ListTile(
                      title: Text(_model.title ?? ''),
                      subtitle: Text(_model.author?.nickname ?? ''),
                      trailing: Container(
                        width: 102,
                        height: 76,
                        decoration: BoxDecoration(
                          color: ColorConfig.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _model.coverImage ??
                              'http://via.placeholder.com/102x76',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey,
                            height: 76,
                            width: 102,
                          ),
                        ),
                      ),
                      onTap: () {
                        _gotoDetailPage(index);
                      },
                    ),
                  );
                },
                childCount: homePostP.posts.length,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _gotoDetailPage(int index) {
    STRouters.push(
      context,
      PostDetailPage(
        model: homePostProvider.posts[index],
      ),
    );
  }

  Future _loadAndRefresh() async {
    NewsLoading.start(context);
    bool isSuc = await homePostProvider.initOrRefresh();
    NewsLoading.stop();
    if (isSuc)
      EasySnackbar.show(
        context: context,
        backgroundColor: ColorConfig.backgroundColor,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 56),
        padding: EdgeInsets.symmetric(vertical: 5),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            '为您推荐${NewsPerpage.finalPerPage}条内容',
            style: NewsTextStyle.style14NormalWhite,
          ),
        ),
      );
  }

  Future _loadMore() async {
    NewsLoading.start(context);
    await homePostProvider.loadMore();
    NewsLoading.stop();
  }
}
