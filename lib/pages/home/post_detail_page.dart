import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.postID}) : super(key: key);

  final String? postID;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
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
      body: EmptyViewWidget(
        content: '内容加载中。。。',
      ),
    );
  }
}
