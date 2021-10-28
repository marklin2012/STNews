import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_widget/circle_cell.dart';
import 'package:stnews/pages/circle/search_circle_page.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/providers/circle_provider.dart';
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
    Future.delayed(Duration(milliseconds: 500), () {
      circleProvider.initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
            tag: SearchCirclePage.searchCircleHeroTag,
            child: STButton.icon(
                backgroundColor: Colors.transparent,
                icon: Icon(STIcons.commonly_search),
                onTap: () {
                  STRouters.push(context, SearchCirclePage());
                })),
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
        );
      }

      return Padding(
          padding: EdgeInsets.symmetric(horizontal: NewsScale.sw(4, context)),
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: 2,
            itemCount: circleProvider.lists.length,
            mainAxisSpacing: NewsScale.sh(4, context),
            crossAxisSpacing: NewsScale.sh(4, context),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: index == 1
                    ? EdgeInsets.only(top: NewsScale.sh(40, context))
                    : EdgeInsets.zero,
                child: CircleCell(
                  circleModel: circleP.lists[index],
                ),
              );
            },
            staggeredTileBuilder: (int index) {
              return StaggeredTile.fit(1);
            },
          ));
    });
  }

  Widget _buildPublish() {
    return FloatingActionButton(
      backgroundColor: ColorConfig.baseFirBule,
      foregroundColor: ColorConfig.accentColor,
      onPressed: () {},
      child: Icon(
        STIcons.commonly_camera,
        size: 20,
        color: ColorConfig.primaryColor,
      ),
    );
  }
}
