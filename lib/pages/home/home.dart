import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:stnews/models/news_model.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/service/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EasyRefreshController _controller;
  late List<NewsModel> _lists;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _lists = [
      NewsModel(id: '0', title: 'title0', author: 'author0', image: 'image0'),
      NewsModel(id: '1', title: 'title1', author: 'author1', image: 'image1'),
      NewsModel(id: '2', title: 'title2', author: 'author2', image: 'image2'),
      NewsModel(id: '3', title: 'title3', author: 'author3', image: 'image3'),
      NewsModel(id: '4', title: 'title4', author: 'author4', image: 'image4'),
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
      appBar: AppBar(
        leading: STButton.icon(
            backgroundColor: Colors.transparent,
            icon: Icon(STIcons.commonly_search),
            onTap: () {
              Api.setAuthHeader(
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIxMjMgNDU2NyIsImlhdCI6MTYzMDUwNTEzN30.SCtRhjDnjzKS9W_fUf7oFvMAWq8LFtgv-kizP9iBovw');
            }),
        title: Text('资讯'),
      ),
      body: EasyRefresh(
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
            _lists = [
              NewsModel(
                  id: '0', title: 'title0', author: 'author0', image: 'image0'),
              NewsModel(
                  id: '1', title: 'title1', author: 'author1', image: 'image1'),
              NewsModel(
                  id: '2', title: 'title2', author: 'author2', image: 'image2'),
              NewsModel(
                  id: '3', title: 'title3', author: 'author3', image: 'image3'),
              NewsModel(
                  id: '4', title: 'title4', author: 'author4', image: 'image4'),
            ];
            setState(() {});
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            _getNewsData();
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

  void _getNewsData() {
    final _lastM = _lists.last;
    final _lastIndex = int.parse(_lastM.id!);
    for (var i = _lastIndex + 1; i < _lastIndex + 10; i++) {
      final _newM = NewsModel(
        id: i.toString(),
        title: 'title' + i.toString(),
        author: 'author' + i.toString(),
        image: 'image' + i.toString(),
      );
      _lists.add(_newM);
    }
    setState(() {});
  }
}
