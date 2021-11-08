import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_detail_page.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';

import 'package:stnews/pages/common/news_loading.dart';
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
      userHomeProvider.userID = widget.userID ?? '';
      _requestData();
    });
  }

  Future _requestData() async {
    NewsLoading.start(context);
    await userHomeProvider.getUserInfoData();
    // 非自己时查询是否关注该用户
    if (widget.userID != UserProvider.shared.user.id) {
      await userHomeProvider.getFavouritedUser();
    }
    NewsLoading.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Consumer<UserHomeProvider>(
        builder: (BuildContext context, UserHomeProvider userHomeP, _) {
      return CustomScrollView(
        slivers: [
          PersonHomeHeader(
            user: userHomeP.infoModel.user,
            isSelf: userHomeP.isSelf,
            isFavouritedUser: userHomeP.isFavouritedUser,
            followerCount: userHomeP.infoModel.followerCount,
            fansCount: userHomeP.infoModel.fansCount,
            favouritedTap: (bool isFav) {
              _changeFavouriteStatus(isFav);
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
                _jumpMomentDetailComment(moment: model);
              },
              favourtieTap: (MomentModel model, bool isFaved) {
                _changeFavoriteMomentStatus(
                    momentID: model.id, isFaved: isFaved);
              },
              thumbupTap: (MomentModel model, bool isThumbup) {
                _changeThumbupMomentStatus(
                    momentID: model.id, isThumbup: isThumbup);
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

  void _jumpMomentDetailComment({MomentModel? moment}) {
    if (moment == null) return;
    STRouters.push(
        context,
        CircleDetailPage(
          moment: moment,
          positComment: true,
        ));
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
