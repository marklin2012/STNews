import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/pages/common/news_home_cell.dart';
import 'package:stnews/pages/home/post_detail_page.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PersonHomePosts extends StatefulWidget {
  const PersonHomePosts({Key? key}) : super(key: key);

  @override
  _PersonHomePostsState createState() => _PersonHomePostsState();
}

class _PersonHomePostsState extends State<PersonHomePosts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserHomeProvider>(
        builder: (BuildContext context, UserHomeProvider userHomeP, _) {
      if (userHomeP.infoModel.post == null ||
          (userHomeP.infoModel.post != null &&
              userHomeP.infoModel.post!.isEmpty))
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                210,
            child: EmptyViewWidget(
              content: '暂无发布的内容',
            ),
          ),
        );
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final _model = userHomeP.infoModel.post?[index];
            return Container(
              height: 92,
              child: NewsHomeCell(
                title: Text(
                  _model?.title ?? '',
                  style: NewsTextStyle.style16NormalBlack,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subTitle: Text(
                  _model?.author?.nickname ?? '',
                  style: NewsTextStyle.style12NormalThrGrey,
                ),
                trailing: Hero(
                  tag: NewsHeroTags.postDetailImageTag + (_model?.id ?? ''),
                  child: NewsImage.networkImage(
                    path: _model?.coverImage ??
                        'http://via.placeholder.com/102x76',
                    width: 102,
                    height: 76,
                    defaultChild: Container(
                      color: Colors.grey,
                    ),
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
    });
  }
}
