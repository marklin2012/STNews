import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WebViewPage extends StatelessWidget {
  final String? title;
  final String? content;

  const WebViewPage({Key? key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: Html(data: content ?? "<p>这里是协议内容！</p>"),
    );
  }
}
