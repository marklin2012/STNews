import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:stnews/models/comment_model.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/post_detail_inherited.dart';
import 'package:stnews/pages/home/detail_widget/deatil_header.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/pages/person/person_home_page.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.model}) : super(key: key);

  final PostModel? model;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;
  late PostModel _model;
  List<CommentModel> _comments = [];
  late ValueNotifier<List<CommentModel>> _commentsNoti;

  final GlobalKey _commentsKey = GlobalKey(debugLabel: 'comments'); // 控件的key
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = EasyRefreshController();
    _model = widget.model ?? PostModel();
    _commentsNoti = ValueNotifier(_comments);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _findRenderObject();
    });
    _getCommentsAndPostFavourited();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _findRenderObject() {
    RenderObject? renderobject =
        _commentsKey.currentContext?.findRenderObject();
    if (renderobject != null && renderobject is RenderBox) {
      RenderBox renderBox = renderobject;
      _offset = renderBox.localToGlobal(Offset.zero);
      setState(() {});
    }
  }

  Future _getCommentsAndPostFavourited() async {
    ResultData result1 = await Api.getThumpubPost(id: _model.id);
    if (result1.success) {
      bool _isThumbup = result1.data['isThumbup'] as bool;
      _model.isliked = !_isThumbup;
    }

    setState(() {});

    _getComments();
  }

  Future _getComments() async {
    ResultData result = await Api.getCommentList(postid: widget.model!.id);
    if (result.success) {
      final _temps = result.data['comments'] as List;
      _comments = _temps.map((e) => CommentModel.fromJson(e)).toList();
      _commentsNoti.value = _comments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Icon(
            STIcons.direction_leftoutlined,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlankPutKeyborad(
        child: buildChildWidget(),
      ),
    );
  }

  Widget buildChildWidget() {
    return PostDetailInheritedWidget(
      _model,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 44 + MediaQuery.of(context).padding.bottom,
            child: ValueListenableBuilder(
              valueListenable: _commentsNoti,
              builder: (context, List<CommentModel> values, _) {
                return EasyRefresh(
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
                  onLoad: () async {
                    await Future.delayed(Duration(seconds: 2), () {
                      // TODO 上拉加载更多
                      _controller.finishLoad();
                    });
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: DetailHeader(
                          authorTap: () {
                            STRouters.push(context, PersonHomePage());
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 500,
                          child: Center(
                            child: Text('WebView'),
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
                              bottom: BorderSide(color: Color(0xFFDFE2E7)),
                            ),
                          ),
                          child: Text(
                            '评论 (${values.length})',
                            style: NewsTextStyle.style16BoldBlack,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return CommentCell(
                              model: values[index],
                            );
                          },
                          childCount: values.length,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: DetailFooter(
              isLiked: _model.isliked,
              messageTap: _scrollToComments,
              commitTap: (CommentModel? comment) {
                if (comment != null) {
                  _comments.add(comment);
                  _commentsNoti.value = _comments;
                } else {
                  _getComments();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToComments() {
    double animatH = 0;
    double visibleH = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top -
        44;
    if (_offset.dy > visibleH) {
      animatH = _offset.dy - visibleH;
    }
    _scrollController.animateTo(animatH,
        duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
  }
}
