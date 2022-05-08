import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_home_cell.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/pages/home/search_post_page.dart';
import 'package:stnews/providers/home_post_provider.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const recommendHight = 32.0;

class _HomePageState extends State<HomePage> {
  HomePostProvider get homePostProvider => Provider.of(context, listen: false);

  @override
  void initState() {
    super.initState();
    homePostProvider.initOrRefresh();
  }

  @override
  void dispose() {
    EasySnackbar.hide(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.backgroundColor,
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Hero(
            tag: NewsHeroTags.searchHeaderTag,
            child: Icon(STIcons.commonly_search_outline),
          ),
          onTap: () {
            STRouters.push(context, SearchPostPage());
          },
        ),
        title: Text(
          '资讯',
          style: TextStyle(color: Colors.black),
        ),
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
      List<String> _pageLists = homePostP.banners.map((PostModel e) {
        return e.coverImage ?? '';
      }).toList();
      return NewsEasyRefresh(
        hasHeader: true,
        hasFooter: true,
        onRefresh: _loadAndRefresh,
        onLoad: _loadMore,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageViewWidget(
                pageList: _pageLists,
                height: 120,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final _model = homePostP.posts[index];
                  return NewsHomeCell(
                    title: Text(
                      _model.title ?? '',
                      style: NewsTextStyle.style16NormalBlack,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subTitle: Text(
                      _model.author?.nickname ?? '',
                      style: NewsTextStyle.style12NormalThrGrey,
                    ),
                    trailing: Hero(
                      tag: NewsHeroTags.postDetailImageTag + (_model.id ?? ''),
                      child: NewsImage.networkImage(
                        path: _model.coverImage ??
                            'http://via.placeholder.com/102x76',
                        width: 102,
                        height: 76,
                        defaultChild: Container(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    onTap: () {
                      _gotoDetailPage(index);
                    },
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
    bool isSuc = await homePostProvider.initOrRefresh();
    debugPrint('---------' + DateTime.now().toString());
    Future.delayed(Duration(milliseconds: 1200), () {
      debugPrint('---------' + DateTime.now().toString());
      if (isSuc) {
        EasySnackbar.show(
          context: context,
          backgroundColor: ColorConfig.backgroundColor,
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 44),
          padding: EdgeInsets.symmetric(vertical: 5),
          title: Container(
            alignment: Alignment.center,
            color: ColorConfig.baseThrBlue,
            height: recommendHight,
            child: Text(
              '为您推荐${NewsPerpage.finalPerPage}条内容',
              style: NewsTextStyle.style14NormalWhite,
            ),
          ),
        );
      }
    });
  }

  Future<ResultRefreshData> _loadMore() async {
    NewsLoading.start(context);
    ResultRefreshData data = await homePostProvider.loadMore();
    NewsLoading.stop();
    return data;
  }
}
