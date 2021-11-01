import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/scroll_header.dart';
import 'package:stnews/pages/home/detail_widget/deatil_header.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/pages/person/person_home/person_home_page.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.model}) : super(key: key);

  final PostModel? model;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ScrollController _scrollController;

  final GlobalKey _commentsKey = GlobalKey(debugLabel: 'comments'); // 控件的key
  Offset _offset = Offset.zero;

  PostDetailProvider get postDetailProvider =>
      Provider.of<PostDetailProvider>(context, listen: false);

  DetailFooterData _data = DetailFooterData.init(true, false, false);
  late ValueNotifier<DetailFooterData> _detailFooterNoti;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    postDetailProvider.postModel = widget.model ?? PostModel();
    postDetailProvider.initComments();
    postDetailProvider.getFavouritedUser();
    _detailFooterNoti = ValueNotifier(_data);
    _initData();
  }

  Future _initData() async {
    bool _isFavPost = await postDetailProvider.getPostFavourited();
    bool _isLikePost = await postDetailProvider.getPostLiked();

    _detailFooterNoti.value = DetailFooterData(
      isCommited: true,
      isFavourited: _isFavPost,
      isLiked: _isLikePost,
      commentedCount: postDetailProvider.comments.length.toString(),
    );
    _data = _detailFooterNoti.value;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 定位评论的偏移量
  void _findRenderObject() {
    RenderObject? renderobject =
        _commentsKey.currentContext?.findRenderObject();
    if (renderobject != null && renderobject is RenderBox) {
      RenderBox renderBox = renderobject;
      _offset = renderBox.localToGlobal(Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPutKeyborad(
        child: buildChildWidget(),
        onTap: () {
          switchFooterCommited(true);
        },
      ),
    );
  }

  Widget buildChildWidget() {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 44),
            child: NewsEasyRefresh(
              hasFooter: true,
              onLoad: _loadMore,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  ScrollHeader(
                    maxExtent: widget.model!.title!.length > 14
                        ? detailHeaderHeight
                        : 142,
                    minExtent: 44,
                    builder: (context, offset, __) {
                      return _consumerPostModel(
                        (buildContext, provider, child) => DetailHeader(
                          offset: offset,
                          authorTap: () {
                            if (provider.postModel.author?.id != null) {
                              STRouters.push(
                                context,
                                PersonHomePage(
                                  userID: provider.postModel.author!.id!,
                                  type: PersonHomeShowType.PersonHomeShowPost,
                                ),
                              );
                            }
                          },
                          onFavouritedUser: () async {
                            /// 关注或取消关注该用户
                            NewsLoading.start(context);
                            await postDetailProvider.favouritedUser();
                            NewsLoading.stop();
                          },
                        ),
                      );
                    },
                  ),
                  // 文章内容

                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      // child: Container(
                      //   height: 500,
                      //   color: Colors.yellow,
                      // ),
                      child: Html(
                        data: postDetailProvider.postModel.article,
                        style: {
                          'p': Style(
                            fontSize: FontSize.large,
                            lineHeight: LineHeight(1.4),
                          ),
                          'pre': Style(
                            backgroundColor: Color(0xFF000000),
                            color: Color(0xFFfefefe),
                            padding: EdgeInsets.all(8),
                          )
                        },
                        onImageError: (err, _) {
                          print(err);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      key: _commentsKey,
                      margin: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
                      padding: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorConfig.thrGrey),
                        ),
                      ),
                      child: _consumerPostModel(
                        (buildContext, provider, child) => Text(
                          '评论 (${provider.comments.length})',
                          style: NewsTextStyle.style16BoldBlack,
                        ),
                      ),
                    ),
                  ),
                  _consumerPostModel(
                    (buildContext, provider, child) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return CommentCell(
                            model: provider.comments[index],
                          );
                        },
                        childCount: provider.comments.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
                valueListenable: _detailFooterNoti,
                builder: (BuildContext context, DetailFooterData data, _) {
                  return DetailFooter(
                    data: _data,
                    switchCommitTap: (bool isCommit) {
                      switchFooterCommited(isCommit);
                    },
                    messageTap: _scrollToComments,
                    commentTap: (String content) {
                      _addComment(content);
                    },
                    favouriteTap: (bool isFav) {
                      _favouritedPost(isFav);
                    },
                    likeTap: (bool isLiked) {
                      _likedPost(isLiked);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _consumerPostModel(
      Widget Function(
    BuildContext buildContext,
    PostDetailProvider provider,
    Widget? child,
  )
          builder) {
    return Consumer(builder: builder);
  }

  /// 滑动到评论
  void _scrollToComments() {
    _findRenderObject();
    double animateH = 0.0;
    // 总偏移量
    animateH = _scrollController.offset + _offset.dy;
    double screenH = MediaQuery.of(context).size.height;
    // 测试中的极限值
    double _space = (MediaQuery.of(context).padding.top + 56 + 30);
    if (animateH > screenH - _space) {
      animateH -= screenH;
      animateH += _space;
      double scrollBottom = _scrollController.position.maxScrollExtent;
      if (scrollBottom > animateH + screenH / 3) {
        animateH += screenH / 3;
      }
      _scrollController.animateTo(animateH,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
  }

  void switchFooterCommited(bool isCommit) {
    _data = _data.setCommited(isCommit);
    _detailFooterNoti.value = _data;
  }

  void getCommentCount() {
    int count = postDetailProvider.comments.length;
    _data = _data.setCommentCount(count.toString());
    _detailFooterNoti.value = _data;
  }

  Future<ResultRefreshData> _loadMore() async {
    NewsLoading.start(context);
    ResultRefreshData data = await postDetailProvider.loadMore();
    NewsLoading.stop();
    getCommentCount();
    return data;
  }

  /// 发布评论
  void _addComment(String content) async {
    bool isSuc = await postDetailProvider.addComment(content);
    if (isSuc) {
      FocusScope.of(context).requestFocus(FocusNode());
      int count = postDetailProvider.comments.length;
      _data = _data.setCommentAndCommited(count.toString());
      _detailFooterNoti.value = _data;
    }
  }

  /// 收藏或取消收藏该文章
  void _favouritedPost(bool isFav) async {
    bool _isFav = await postDetailProvider.favouritedPost(isFav);
    _data = _data.setFavPost(_isFav);
    _detailFooterNoti.value = _data;
  }

  /// 点赞或取消点赞该文章
  void _likedPost(bool isLiked) async {
    bool _isLiked = await postDetailProvider.likedPost(isLiked);
    _data = _data.setLikePost(_isLiked);
    _detailFooterNoti.value = _data;
  }
}
