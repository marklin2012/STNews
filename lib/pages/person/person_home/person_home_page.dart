import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_detail_page.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';

import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/common/scroll_header.dart';
import 'package:stnews/pages/person/person_widgets/person_home_circles.dart';
import 'package:stnews/pages/person/person_widgets/person_home_header.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

enum PersonHomeShowType {
  PersonHomeShowPost,
  PersonHomeShowCircle,
}

class PersonHomePage extends StatefulWidget {
  const PersonHomePage({
    Key? key,
    this.userID,
    required this.type,
  }) : super(key: key);

  final String? userID;

  final PersonHomeShowType type;

  @override
  _PersonHomePageState createState() => _PersonHomePageState();
}

class _PersonHomePageState extends State<PersonHomePage> {
  UserHomeProvider get userHomeProvider =>
      Provider.of<UserHomeProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.userID == UserProvider.shared.user.id) {
        userHomeProvider.infoModel = UserProvider.shared.info;
      } else {
        userHomeProvider.userID = widget.userID ?? '';
        _requestData();
      }
    });
  }

  Future _requestData() async {
    // NewsLoading.start(context);
    await userHomeProvider.getUserInfoData();
    // 非自己时查询是否关注该用户
    if (widget.userID != UserProvider.shared.user.id) {
      await userHomeProvider.getFavouritedUser();
    }
    // NewsLoading.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<UserHomeProvider>(
        builder: (BuildContext context, UserHomeProvider userHomeP, _) {
      return CustomScrollView(
        slivers: [
          ScrollHeader(
            maxExtent: 172,
            minExtent: 44,
            builder: (BuildContext context, double offset, _) {
              return PersonHomeHeader(
                offset: offset,
                user: userHomeP.infoModel.user,
                isSelf: userHomeP.isSelf,
                isFavouritedUser: userHomeP.isFavouritedUser,
                followerCount: userHomeP.infoModel.followerCount,
                fansCount: userHomeP.infoModel.fansCount,
                favouritedTap: (bool isFav) {
                  _changeFavouriteStatus(isFav);
                },
              );
            },
          ),
          if (userHomeP.hasMoments)
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'TA的作品',
                  style: NewsTextStyle.style17BoldBlack,
                ),
              ),
            ),
          if (userHomeP.hasMoments)
            PersonHomeCircles(
              userModel: userHomeP.infoModel.user,
              moments: userHomeP.infoModel.moments,
              jumpCommentTap: (MomentModel model) {
                _jumpMomentDetailComment(moment: model, positComment: true);
              },
              favourtieTap: (MomentModel model, bool isFaved) {
                _changeFavoriteMomentStatus(
                    momentID: model.id, isFaved: isFaved);
              },
              thumbupTap: (MomentModel model, bool isThumbup) {
                _changeThumbupMomentStatus(
                    momentID: model.id, isThumbup: isThumbup);
              },
              jumpMomentTap: (MomentModel model) {
                _jumpMomentDetailComment(moment: model);
              },
            ),
          if (!userHomeP.hasMoments)
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    210,
                child: EmptyViewWidget(
                  content: '暂无发布的作品',
                ),
              ),
            )
        ],
      );
    });
  }

  void _changeFavouriteStatus(bool isFaved) async {
    NewsLoading.start(context);
    await userHomeProvider.changeFavouritedUserStatus(isFaved);
    NewsLoading.stop();
  }

  void _jumpMomentDetailComment(
      {MomentModel? moment, bool positComment = false}) {
    if (moment == null) return;
    STRouters.push(
      context,
      CircleDetailPage(
        moment: moment,
        positComment: positComment,
      ),
    );
  }

  void _changeFavoriteMomentStatus({String? momentID, bool? isFaved}) async {
    if (momentID == null || momentID.isEmpty) return;
    await userHomeProvider.favouritedMoment(momentID: momentID, isFav: isFaved);
  }

  void _changeThumbupMomentStatus({String? momentID, bool? isThumbup}) async {
    if (momentID == null || momentID.isEmpty) return;
    await userHomeProvider.thumbupMoment(
        momentID: momentID, isThumbup: isThumbup);
  }
}
