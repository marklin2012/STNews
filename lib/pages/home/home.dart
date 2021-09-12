import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/pages/home/search_post_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/st_routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EasyRefreshController _controller;
  List<PostModel> _lists = [];

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: FutureBuilder(
          future: Api.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              ResultData? result;
              if (snapshot.hasData) {
                result = snapshot.data as ResultData;
                if (result.success) {
                  List _data = result.data as List;
                  _lists = _data.map((e) => PostModel.fromJson(e)).toList();
                  return _buildContent();
                }
              }
              return EmptyViewWidget(
                content: '内容加载失败,请点击重试',
                onTap: () {
                  // TODO 去重试
                },
              );
            }
            return EmptyViewWidget.loading();
          }),
    );
  }

  Widget _buildContent() {
    return EasyRefresh(
      controller: _controller,
      header: ClassicalHeader(
        textColor: Color(0xFF888888),
        showInfo: false,
        refreshText: '下拉刷新',
        refreshReadyText: '松开刷新',
        refreshingText: '加载中...',
        refreshedText: '完成刷新',
        refreshFailedText: '刷新失败',
      ),
      footer: ClassicalFooter(
        loadText: '上拉加载',
        loadReadyText: '松开加载',
        loadingText: '加载中...',
        loadedText: '完成加载',
        loadFailedText: '加载更多失败',
        noMoreText: '我是有底线的',
        showInfo: false,
        textColor: Color(0xFF888888),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          // TODO 下拉刷新
          _controller.finishRefresh();
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          // TODO 上拉加载更多
          _controller.finishLoad();
        });
      },
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
}
