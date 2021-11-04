import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_content.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_nav_header.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/providers/circle_detail_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class CircleDetailPage extends StatefulWidget {
  const CircleDetailPage({Key? key, required this.moment}) : super(key: key);

  final MomentModel moment;

  @override
  _CircleDetailPageState createState() => _CircleDetailPageState();
}

class _CircleDetailPageState extends State<CircleDetailPage> {
  CircleDetailProvider get circleDetailProvider =>
      Provider.of<CircleDetailProvider>(context, listen: false);

  DetailFooterData _data = DetailFooterData.init(true, false, false);
  late ValueNotifier<DetailFooterData> _detailFooterNoti;

  late ValueNotifier<bool> _favAuthorNoti;

  @override
  void initState() {
    super.initState();
    circleDetailProvider.moment = widget.moment;
    _detailFooterNoti = ValueNotifier(_data);
    _favAuthorNoti = ValueNotifier(false);
    // circleDetailProvider.getMomentDetail();
    _initFavAuthor();
    _initFooterData();
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
      commentedCount: circleDetailProvider.comments.length.toString(),
    );
    _detailFooterNoti.value = _data;
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
    return Padding(
      padding: EdgeInsets.only(top: 52),
      child: Container(
        child: NewsEasyRefresh(
          hasFooter: true,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CircleDetailContent(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CommentCell();
                  },
                  childCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              messageTap: () {},
              commentTap: (String content) {},
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
    _data = _data.setCommited(isCommit);
    _detailFooterNoti.value = _data;
  }

  void _changeFavAuthorStatus(bool value) async {
    NewsLoading.start(context);
    bool _isFaved = await circleDetailProvider.favouritedUser(isFaved: value);
    _favAuthorNoti.value = _isFaved;
    NewsLoading.stop();
  }

  /// 收藏或取消收藏该文章
  void _favouritedMoment(bool isFav) async {
    bool _isFav = await circleDetailProvider.favouritedMoment(isFav);
    _data = _data.setFavPost(_isFav);
    _detailFooterNoti.value = _data;
  }

  /// 点赞或取消点赞该文章
  void _thumbupMoment(bool isThumbup) async {
    bool _isThumbup = await circleDetailProvider.thumbupMoment(isThumbup);
    _data = _data.setLikePost(_isThumbup);
    _detailFooterNoti.value = _data;
  }
}
