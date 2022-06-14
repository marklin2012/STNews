import 'package:flutter/material.dart';
import 'package:stnews/pages/mall/stores/stores_grid_view_page.dart';

class StoresCategoryDetailPage extends StatefulWidget {
  const StoresCategoryDetailPage({Key? key}) : super(key: key);

  @override
  State<StoresCategoryDetailPage> createState() =>
      _StoresCategoryDetailPageState();
}

class _StoresCategoryDetailPageState extends State<StoresCategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('店铺搜索'),
      ),
      body: StoresGridViewPage(),
    );
  }
}
