import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_easy_refresh.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/home/detail_widget/deatil_header.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/pages/person/person_home_page.dart';
import 'package:stnews/providers/post_detail_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.model}) : super(key: key);

  final PostModel? model;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ScrollController _scrollController;

  final GlobalKey _commentsKey = GlobalKey(debugLabel: 'comments'); // 控件的key
  Offset _offset = Offset.zero;

  PostDetailProvider get postDetailProvider =>
      Provider.of<PostDetailProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _findRenderObject();
    });
    postDetailProvider.postModel = widget.model ?? PostModel();
    postDetailProvider.initComments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Icon(
            STIcons.direction_leftoutlined,
            color: ColorConfig.textFirColor,
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
    return Consumer<PostDetailProvider>(builder: (context, postDetP, _) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 44 + MediaQuery.of(context).padding.bottom,
            child: NewsEasyRefresh(
              hasFooter: true,
              onLoad: _loadMore,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: DetailHeader(
                      authorTap: () {
                        if (postDetP.postModel.author?.id != null) {
                          STRouters.push(
                            context,
                            PersonHomePage(
                              userID: postDetP.postModel.author!.id!,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Html(
                        data: postDetP.postModel.article,
                        style: {
                          'p': Style(
                            fontSize: FontSize.large,
                            lineHeight: LineHeight(1.4),
                          ),
                          'pre': Style(
                            backgroundColor: Color(0xFFefefef),
                            color: Color(0xFF333),
                            padding: EdgeInsets.all(8),
                          )
                        },
                        onImageError: (err, _) {
                          print(err);
                        },
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
                          bottom: BorderSide(color: ColorConfig.thrGrey),
                        ),
                      ),
                      child: Text(
                        '评论 (${postDetP.comments.length})',
                        style: NewsTextStyle.style16BoldBlack,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CommentCell(
                          model: postDetP.comments[index],
                        );
                      },
                      childCount: postDetP.comments.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: DetailFooter(
              messageTap: _scrollToComments,
            ),
          ),
        ],
      );
    });
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

  Future _loadMore() async {
    NewsLoading.start(context);
    await postDetailProvider.loadMore();
    NewsLoading.stop();
  }
}
