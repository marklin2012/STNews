import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:stnews/models/comment_model.dart';

import 'package:stnews/models/post_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/post_detail_inherited.dart';
import 'package:stnews/pages/home/detail_widget/deatil_header.dart';
import 'package:stnews/pages/home/detail_widget/detail_comment_cell.dart';
import 'package:stnews/pages/home/detail_widget/detail_footer.dart';
import 'package:stnews/pages/person/person_home_page.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.model}) : super(key: key);

  final PostModel? model;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late EasyRefreshController _controller;
  late List<CommentModel>? _comments;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _comments = [
      CommentModel(
        postid: '1',
        content: '评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述',
        user: UserModel(id: '1', nickname: '111', avatar: ''),
        favourites: '11',
        pubishtime: DateTime.now(),
      ),
      CommentModel(
        postid: '2',
        content: '评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述',
        user: UserModel(id: '2', nickname: '222', avatar: ''),
        favourites: '22',
        pubishtime: DateTime.now().add(Duration(days: -1)),
      ),
      CommentModel(
        postid: '3',
        content: '评论内容描述评论内容描述',
        user: UserModel(id: '3', nickname: '333', avatar: ''),
        favourites: '33',
        pubishtime: DateTime.now().add(Duration(days: -2)),
      ),
      CommentModel(
        postid: '4',
        content:
            '评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述评论内容描述',
        user: UserModel(id: '4', nickname: '4444', avatar: ''),
        favourites: '44',
        pubishtime: DateTime.now().add(Duration(days: -10)),
      ),
      CommentModel(
        postid: '5',
        content: '评论内容描述',
        user: UserModel(id: '5', nickname: '555555', avatar: ''),
        favourites: '555',
        pubishtime: DateTime.now().add(Duration(days: -555)),
      ),
    ];
    // Api.getPostDetail(widget.model!.id!).then((reslut) {
    //   if (reslut.success) {}
    // });

    // Api.getCommentList(postid: widget.model!.id).then((reslut) {
    //   if (reslut.success) {}
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Icon(
            STIcons.direction_leftoutlined,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: buildChildWidget(),
      // body: FutureBuilder(
      //   future: Api.getCommentList(postid: widget.model!.id),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       ResultData? result;
      //       if (snapshot.hasData) {
      //         result = snapshot.data as ResultData;
      //         if (result.success) {
      //           return buildChildWidget();
      //         }
      //       }
      //       return EmptyViewWidget(
      //         content: '内容加载失败,请点击重试',
      //         onTap: () {
      //           // TODO 去重试
      //         },
      //       );
      //     }
      //     return EmptyViewWidget.loading();
      //   },
      // ),
    );
  }

  Widget buildChildWidget() {
    return PostDetailInheritedWidget(
      widget.model!,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 44 + MediaQuery.of(context).padding.bottom,
            child: EasyRefresh(
              footer: ClassicalFooter(
                loadText: '上拉加载',
                loadReadyText: '松开加载',
                loadingText: '加载中...',
                loadedText: '完成加载',
                loadFailedText: '加载更多失败',
                noMoreText: '我是有底线的',
                showInfo: false,
                textColor: Color(0xFF888888),
              ),
              onLoad: () async {
                await Future.delayed(Duration(seconds: 2), () {
                  // TODO 上拉加载更多
                  _controller.finishLoad();
                });
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: DetailHeader(
                      authorTap: () {
                        STRouters.push(context, PersonHomePage());
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 500,
                      color: Colors.red,
                      child: Center(
                        child: Text('WebView'),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
                      padding: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFDFE2E7)),
                        ),
                      ),
                      child: Text(
                        '评论 (${_comments?.length})',
                        style: NewsTextStyle.style16BoldBlack,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Expanded(
                          child: CommentCell(
                            model: _comments?[index],
                          ),
                        );
                      },
                      childCount: _comments?.length,
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
              messageTap: () {
                // TODO 定位到评论
              },
            ),
          ),
        ],
      ),
    );
  }
}
