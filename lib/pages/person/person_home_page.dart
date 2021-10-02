import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_avatar_widget.dart';
import 'package:stnews/pages/common/news_icon_text_widget.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_cache_image.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonHomePage extends StatefulWidget {
  const PersonHomePage({Key? key, this.userID}) : super(key: key);

  final String? userID;

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
    await userHomeProvider.getFavouritedUser();
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
    return Consumer<UserHomeProvider>(builder: (context, userHomeP, _) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(userHomeP),
          ),
          if (userHomeP.infoModel.post != null &&
              userHomeP.infoModel.post!.isNotEmpty)
            _buildPost(userHomeP),
          if (userHomeP.infoModel.post == null ||
              (userHomeP.infoModel.post != null &&
                  userHomeP.infoModel.post!.isEmpty))
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    210,
                child: EmptyViewWidget(
                  content: '暂无发布的内容',
                ),
              ),
            )
        ],
      );
    });
  }

  Widget _buildHeader(UserHomeProvider userHomeP) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          ListTile(
            leading: NewsAvatarWidget(
              size: 60,
              child: STCaCheImage.loadingImage(
                  imageUrl: userHomeP.infoModel.user?.avatar),
            ),
            title: Text(
              userHomeP.infoModel.user?.nickname ?? '',
              style: TextStyle(fontSize: FONTSIZE18, fontWeight: FONTWEIGHT500),
            ),
            trailing: userHomeP.isSelf
                ? null
                : STButton(
                    text: userHomeP.isFavouritedUser ? '已关注' : '关注',
                    type: STButtonType.outline,
                    size: STButtonSize.small,
                    onTap: _changeFavouriteStatus,
                  ),
          ),
          Container(
            color: ColorConfig.backgroundColor,
            margin: EdgeInsets.symmetric(vertical: 12.0),
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewsIconTextWidget(
                  icon: Icons.favorite,
                  title: (userHomeP.infoModel.followerCount ?? 0).toString(),
                  unit: '关注',
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: ColorConfig.thrGrey,
                ),
                NewsIconTextWidget(
                  icon: Icons.favorite_outline,
                  title: (userHomeP.infoModel.fansCount ?? 0).toString(),
                  unit: '粉丝',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SliverList _buildPost(UserHomeProvider userHomeP) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final _model = userHomeP.infoModel.post?[index];
          return Container(
            height: 92,
            child: ListTile(
              title: Text(_model?.title ?? ''),
              subtitle: Text(_model?.author?.nickname ?? ''),
              trailing: CachedNetworkImage(
                imageUrl:
                    _model?.coverImage ?? 'http://via.placeholder.com/500x200',
                width: 102,
                height: 76,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                STRouters.push(
                  context,
                  PostDetailPage(
                    model: _model,
                  ),
                );
              },
            ),
          );
        },
        childCount: userHomeP.infoModel.post?.length,
      ),
    );
  }

  void _changeFavouriteStatus() async {
    NewsLoading.start(context);
    bool _isFav = await userHomeProvider.changeFavouritedUserStatus();
    Provider.of<PostDetailProvider>(context, listen: false)
        .userHomeChangeStatus(status: _isFav, userID: userHomeProvider.userID);
    NewsLoading.stop();
  }
}
