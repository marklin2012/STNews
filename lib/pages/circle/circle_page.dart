import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_detail_page.dart';
import 'package:stnews/pages/circle/circle_publish_page.dart';
import 'package:stnews/pages/circle/circle_widget/circle_cell.dart';
import 'package:stnews/pages/circle/search_circle_page.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/person/person_home/person_home_page.dart';
import 'package:stnews/providers/circle_provider.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/st_scale.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({Key? key}) : super(key: key);

  @override
  _CirclePageState createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  CircleProvider get circleProvider =>
      Provider.of<CircleProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    circleProvider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Hero(
            tag: NewsHeroTags.searchHeaderTag,
            child: Icon(STIcons.commonly_search),
          ),
          onTap: () {
            STRouters.push(context, SearchCirclePage());
          },
        ),
        title: Text('推荐'),
      ),
      body: _buildContent(),
      floatingActionButton: _buildPublish(),
    );
  }

  Widget _buildContent() {
    return Consumer<CircleProvider>(
        builder: (BuildContext context, CircleProvider circleP, _) {
      if (circleP.isEmpty) {
        return EmptyViewWidget(
          content: '暂无数据，点击重新加载',
          onTap: () {
            circleProvider.initData();
          },
        );
      }

      return Padding(
        padding: EdgeInsets.all(NewsScale.sw(4, context)),
        child: NewsEasyRefresh(
          hasHeader: true,
          hasFooter: true,
          onRefresh: () async {
            circleProvider.initData();
          },
          onLoad: _loadMore,
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: 2,
            itemCount: circleProvider.lists.length,
            mainAxisSpacing: NewsScale.sh(4, context),
            crossAxisSpacing: NewsScale.sw(4, context),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                // margin: index == 1
                //     ? EdgeInsets.only(top: NewsScale.sh(40, context))
                //     : EdgeInsets.zero,
                child: CircleCell(
                  circleModel: circleP.lists[index],
                  authorTap: (String? authorID) {
                    if (authorID == null) return;
                    // 去个人圈子主页
                    STRouters.push(
                      context,
                      PersonHomePage(
                        userID: authorID,
                        type: PersonHomeShowType.PersonHomeShowCircle,
                      ),
                    );
                  },
                  thumbupedTap: (bool? thumbuped) async {
                    await circleProvider.thumbupMoment(
                        index: index, isThumbup: thumbuped);
                  },
                  circleTap: (MomentModel? model) {
                    if (model == null) return;
                    // 去圈子详情页
                    STRouters.push(
                      context,
                      CircleDetailPage(moment: model),
                    );
                  },
                ),
              );
            },
            staggeredTileBuilder: (int index) {
              return StaggeredTile.fit(1);
            },
          ),
        ),
      );
    });
  }

  Widget _buildPublish() {
    return FloatingActionButton(
      backgroundColor: ColorConfig.baseFirBule,
      foregroundColor: ColorConfig.accentColor,
      onPressed: () {
        // 去发布页
        STRouters.push(context, CirclePublishPage());
      },
      child: Icon(
        STIcons.commonly_camera,
        size: 20,
        color: ColorConfig.primaryColor,
      ),
    );
  }

  Future<ResultRefreshData> _loadMore() async {
    NewsLoading.start(context);
    ResultRefreshData data = await circleProvider.loadMore();
    NewsLoading.stop();
    return data;
  }
}
