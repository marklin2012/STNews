import 'package:flutter/material.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({Key? key}) : super(key: key);

  @override
  _CirclePageState createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圈圈'),
      ),
    );
  }
}
