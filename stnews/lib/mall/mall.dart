import 'package:flutter/material.dart';

class MallPage extends StatefulWidget {
  const MallPage({Key? key}) : super(key: key);

  @override
  _MallPageState createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商城'),
      ),
    );
  }
}
