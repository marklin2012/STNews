import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key, this.title, this.url}) : super(key: key);

  final String? title;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
    );
  }
}
