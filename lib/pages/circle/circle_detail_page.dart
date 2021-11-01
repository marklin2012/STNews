import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_content.dart';
import 'package:stnews/pages/circle/circle_widget/circle_detail_nav_header.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class CircleDetailPage extends StatefulWidget {
  const CircleDetailPage({Key? key}) : super(key: key);

  @override
  _CircleDetailPageState createState() => _CircleDetailPageState();
}

class _CircleDetailPageState extends State<CircleDetailPage> {
  DetailFooterData _data = DetailFooterData.init(true, false, false);
  late ValueNotifier<DetailFooterData> _detailFooterNoti;

  @override
  void initState() {
    super.initState();
    _detailFooterNoti = ValueNotifier(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPutKeyborad(
        child: _buildBody(),
        onTap: () {},
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
          '发表人',
          style: NewsTextStyle.style14NormalBlack,
        ),
        trailing: STButton(
          type: STButtonType.outline,
          size: STButtonSize.small,
          text: '已关注',
          textStyle: NewsTextStyle.style16NormalThrGrey,
          borderColor: ColorConfig.thrGrey,
          onTap: () {
            // 切换是否关注
          },
        ),
      ),
    );
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
      child: DetailFooter(
          data: _data,
          switchCommitTap: (bool value) {
            switchFooterCommited(value);
          }),
    );
  }

  void switchFooterCommited(bool isCommit) {
    _data = _data.setCommited(isCommit);
    _detailFooterNoti.value = _data;
  }
}
