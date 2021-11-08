import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_comment_model.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_widget/circle_comment_cell.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_content.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_nav_header.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/providers/circle_detail_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class CircleDetailPage extends StatefulWidget {
  const CircleDetailPage({
    Key? key,
    required this.moment,
    this.positComment,
  }) : super(key: key);

  final MomentModel moment;

  final bool? positComment;

  @override
  _CircleDetailPageState createState() => _CircleDetailPageState();
}

class _CircleDetailPageState extends State<CircleDetailPage> {
  late ScrollController _scrollController;

  final GlobalKey _detailContentKey =
      GlobalKey(debugLabel: 'detailContent'); // 控件的key
  Offset _offset = Offset.zero;
  double _detailContentH = 0;

  CircleDetailProvider get circleDetailProvider =>
      Provider.of<CircleDetailProvider>(context, listen: false);

  DetailFooterData _data = DetailFooterData.init();
  late ValueNotifier<DetailFooterData> _detailFooterNoti;

  late ValueNotifier<bool> _favAuthorNoti;

  MomentCommentModel? _commentModel;

  @override
  void dispose() {
    _scrollController.dispose();
    _detailFooterNoti.dispose();
    _favAuthorNoti.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    circleDetailProvider.moment = widget.moment;
    _detailFooterNoti = ValueNotifier(_data);
    _favAuthorNoti = ValueNotifier(false);
    circleDetailProvider.initComments();
    _initFavAuthor();
    _initFooterData();

    if (widget.positComment ?? false) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _scrollToComments();
      });
    }
  }

  Future _initFavAuthor() async {
    bool _isFav = await circleDetailProvider.getFavouritedUser();
    _favAuthorNoti.value = _isFav;
  }

  Future _initFooterData() async {
    bool _isFavourited = await circleDetailProvider.getMomentFavourited();
    bool _isThumbup = await circleDetailProvider.getMomentThumbup();
    _data = DetailFooterData(
      isCommited: true,
      isFavourited: _isFavourited,
      isLiked: _isThumbup,
      commentedCount: circleDetailProvider.totalCounts.toString(),
    );
    _detailFooterNoti.value = _data;
  }

  /// 定位偏移量
  void _findRenderObject() {
    RenderObject? renderobject =
        _detailContentKey.currentContext?.findRenderObject();
    if (renderobject != null && renderobject is RenderBox) {
      RenderBox renderBox = renderobject;
      _offset = renderBox.localToGlobal(Offset.zero);
      _detailContentH = renderBox.semanticBounds.size.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPutKeyborad(
        child: _buildBody(),
        onTap: () {
          switchFooterCommited(true);
        },
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          _buildNavHeader(),
          _buildContent(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildNavHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 52,
      child: CircleDetailNavHeader(
        leadingImg: NewsImage.defaultAvatar(),
        leadingTitle: Text(
          widget.moment.user?.nickname ?? '发表人',
          style: NewsTextStyle.style14NormalBlack,
        ),
        trailing: _buildHeaderTrailing(),
      ),
    );
  }

  Widget? _buildHeaderTrailing() {
    if ((widget.moment.user?.id ?? '') == UserProvider.shared.user.id!) {
      return null;
    }
    return ValueListenableBuilder(
        valueListenable: _favAuthorNoti,
        builder: (BuildContext context, bool value, _) {
          return STButton(
            type: STButtonType.outline,
            size: STButtonSize.small,
            text: value ? '已关注' : '关注',
            textStyle: NewsTextStyle.style16NormalThrGrey,
            borderColor: ColorConfig.thrGrey,
            onTap: () {
              // 切换是否关注
              _changeFavAuthorStatus(value);
            },
          );
        });
  }

  Widget _buildContent() {
    return Consumer(
        builder: (BuildContext context, CircleDetailProvider circleDetP, _) {
      return Padding(
        padding: EdgeInsets.only(top: 52, bottom: 44),
        child: Container(
          child: NewsEasyRefresh(
            hasFooter: true,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: CircleDetailContent(
                    key: _detailContentKey,
                    images: widget.moment.images,
                    title: widget.moment.title,
                    content: widget.moment.content,
                    commentCount: circleDetP.totalCounts,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      MomentCommentModel? _model = circleDetP.comments[index];
                      return CircleCommentCell(
                        model: _model,
                        replayTap: (MomentCommentModel model) {
                          _commentModel = model;
                          _data = _data.setReplyed(true,
                              nickName: model.user?.nickname);
                          _detailFooterNoti.value = _data;
                        },
                        commentThumbupTap: (String commentID, bool isThumbup) {
                          _thumbupCommentMoment(commentID, isThumbup);
                        },
                      );
                    },
                    childCount: circleDetP.comments.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder(
          valueListenable: _detailFooterNoti,
          builder: (BuildContext context, DetailFooterData data, _) {
            return DetailFooter(
              data: data,
              switchCommitTap: (bool value) {
                switchFooterCommited(value);
              },
              messageTap: _scrollToComments,
              commentTap: (String content) {
                _addMomentComment(content);
              },
              favouriteTap: (bool isFav) {
                _favouritedMoment(isFav);
              },
              likeTap: (bool isThumbup) {
                _thumbupMoment(isThumbup);
              },
            );
          }),
    );
  }

  void switchFooterCommited(bool isCommit) {
    _commentModel = null;
    _data = _data.setCommited(isCommit);
    _detailFooterNoti.value = _data;
  }

  /// 滑动到评论
  void _scrollToComments() {
    _findRenderObject();
    double animateH = 0.0;
    // 总偏移量
    animateH = _scrollController.offset + _offset.dy + _detailContentH;
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

  void _changeFavAuthorStatus(bool value) async {
    NewsLoading.start(context);
    bool _isFaved = await circleDetailProvider.favouritedUser(isFaved: value);
    _favAuthorNoti.value = _isFaved;
    NewsLoading.stop();
  }

  /// 收藏或取消收藏圈子
  void _favouritedMoment(bool isFav) async {
    bool _isFav = await circleDetailProvider.favouritedMoment(isFav);
    _data = _data.setFavPost(_isFav);
    _detailFooterNoti.value = _data;
  }

  /// 点赞或取消点赞圈子
  void _thumbupMoment(bool isThumbup) async {
    bool _isThumbup = await circleDetailProvider.thumbupMoment(isThumbup);
    _data = _data.setLikePost(_isThumbup);
    _detailFooterNoti.value = _data;
  }

  /// 点赞评论
  void _thumbupCommentMoment(String commentID, bool isThumbup) async {
    await circleDetailProvider.commentFavourite(
        commentid: commentID, status: isThumbup);
  }

  /// 发布圈子评论
  void _addMomentComment(String content) async {
    String? reference;
    String? comment;
    if (_commentModel != null) {
      reference = _commentModel!.reference?.id ?? _commentModel!.id;
      comment = _commentModel!.comment?.id ?? _commentModel!.id;
    }
    bool isSuc = await circleDetailProvider.addComment(
      content,
      reference: reference,
      comment: comment,
    );
    if (isSuc) {
      FocusScope.of(context).requestFocus(FocusNode());
      _commentModel = null;
      _data = _data.setCommited(true);
      _data =
          _data.setCommentCount(circleDetailProvider.totalCounts.toString());
      _detailFooterNoti.value = _data;
    }
  }
}
