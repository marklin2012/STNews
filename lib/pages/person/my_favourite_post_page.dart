import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_home_cell.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/providers/favourited_post_provider.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/utils+.dart';

const _selectWidth = 48.0;

class MyFavouritePostPage extends StatefulWidget {
  const MyFavouritePostPage({Key? key}) : super(key: key);

  @override
  _MyFavouritePostPageState createState() => _MyFavouritePostPageState();
}

class _MyFavouritePostPageState extends State<MyFavouritePostPage> {
  bool _isManage = true;
  bool _isSelectAll = false;
  Map<String, bool> _selectedMap = {};

  double _width = 0;
  FavouritedPostProvider get favPostProvider =>
      Provider.of<FavouritedPostProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    favPostProvider.getFavouritedPostsData();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: NewsPopBtn.popBtn(context),
        title: Text('我的收藏'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: STButton(
              type: STButtonType.text,
              text: _isManage ? '管理' : '完成',
              textStyle: NewsTextStyle.style17NormalBlack,
              onTap: () {
                _isManage = !_isManage;
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Consumer<FavouritedPostProvider>(builder: (context, favPostP, _) {
      if (favPostP.posts.isEmpty) {
        return EmptyViewWidget(
          fixTop: 144.0,
          imageBGSize: 100.0,
          content: '暂无任何收藏哦～',
        );
      }
      return Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemExtent: 92,
            itemCount: favPostP.posts.length,
            itemBuilder: (context, index) {
              final _model = favPostP.posts[index];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                reverse: _isManage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: _selectWidth,
                        padding: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: _model.selected ?? false
                            ? Icon(
                                Icons.check_box_outlined,
                                size: 24,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 24,
                              ),
                      ),
                      onTap: () {
                        _selectOneAction(index);
                      },
                    ),
                    Container(
                      width: _width,
                      child: NewsHomeCell(
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
                          tag: NewsHeroTags.postDetailImageTag +
                              (_model.id ?? ''),
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
                          _selectOneAction(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isManage == false)
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).padding.bottom,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  STButton(
                    icon: !_isSelectAll
                        ? Icon(Icons.check_box_outline_blank)
                        : Icon(Icons.check_box_outlined),
                    text: !_isSelectAll ? '全选' : '取消全选',
                    textStyle: NewsTextStyle.style16NormalBlack,
                    backgroundColor: Colors.transparent,
                    onTap: _selectAllBtnAction,
                  ),
                  STButton(
                    text: '删除',
                    textStyle: TextStyle(
                        fontSize: FONTSIZE16,
                        fontWeight: FONTWEIGHT400,
                        color: ColorConfig.primaryColor),
                    onTap: _deletBtnAction,
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  void _selectOneAction(int index) {
    if (index >= favPostProvider.posts.length) return;
    final _model = favPostProvider.posts[index];
    if (_isManage) {
      STRouters.push(
        context,
        PostDetailPage(
          model: _model,
        ),
      );
    } else {
      _model.selected = !(_model.selected ?? false);
      _selectedMap[_model.id!] = _model.selected ?? false;
      _isSelectAll = _isAllSelected();
      setState(() {});
    }
  }

  void _selectAllBtnAction() {
    _isSelectAll = !_isSelectAll;
    for (var post in favPostProvider.posts) {
      post.selected = _isSelectAll;
      _selectedMap[post.id!] = _isSelectAll;
    }
    setState(() {});
  }

  void _deletBtnAction() {
    List<String> postIDs = [];
    for (final key in _selectedMap.keys) {
      if (_selectedMap[key] != null && _selectedMap[key]!) {
        postIDs.add(key);
      }
    }
    NewsLoading.start(context);
    favPostProvider.unFavouritedPosts(postIDs: postIDs);
    NewsLoading.stop();
  }

  bool _isAllSelected() {
    int _res = 0;
    for (final key in _selectedMap.keys) {
      if (_selectedMap[key] != null && _selectedMap[key]!) {
        _res += 1;
      }
    }
    return _res == favPostProvider.posts.length;
  }
}
