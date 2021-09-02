import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/models/news_model.dart';
import 'package:stnews/utils/st_routers.dart';

const _selectWidth = 48.0;

class PersonCollectPage extends StatefulWidget {
  const PersonCollectPage({Key? key}) : super(key: key);

  @override
  _PersonCollectPageState createState() => _PersonCollectPageState();
}

class _PersonCollectPageState extends State<PersonCollectPage> {
  bool _isManage = true;
  bool _isSelectAll = false;
  late List<NewsModel> _lists;
  Map<String, bool> _selectedMap = {};

  double _width = 0;

  @override
  void initState() {
    super.initState();

    _lists = [
      NewsModel(id: '0', title: 'title0', author: 'author0', image: 'image0'),
      NewsModel(id: '1', title: 'title1', author: 'author1', image: 'image1'),
      NewsModel(id: '2', title: 'title2', author: 'author2', image: 'image2'),
      NewsModel(id: '3', title: 'title3', author: 'author3', image: 'image3'),
      NewsModel(id: '4', title: 'title4', author: 'author4', image: 'image4'),
    ];
    for (var item in _lists) {
      _selectedMap[item.id!] = item.selected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
        title: Text('我的收藏'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: STButton(
              type: STButtonType.text,
              text: _isManage ? '管理' : '完成',
              textStyle: TextStyle(
                  fontSize: FONTSIZE17,
                  fontWeight: FONTWEIGHT400,
                  color: Colors.black),
              onTap: () {
                _isManage = !_isManage;
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Stack(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemExtent: 92,
          itemCount: _lists.length,
          itemBuilder: (context, index) {
            final _model = _lists[index];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              reverse: _isManage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: _selectWidth,
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: _model.selected!
                          ? Icon(
                              Icons.check_box_outlined,
                              size: 24,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              size: 24,
                            ),
                    ),
                    onTap: () {
                      _selectOneAction(index);
                    },
                  ),
                  Container(
                    width: _width,
                    child: ListTile(
                      title: Text(_model.title!),
                      subtitle: Text(_model.author!),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      trailing: Container(
                        width: 102,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                      ),
                      onTap: () {
                        _selectOneAction(index);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (_isManage == false)
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                STButton(
                  icon: !_isSelectAll
                      ? Icon(Icons.check_box_outline_blank)
                      : Icon(Icons.check_box_outlined),
                  text: !_isSelectAll ? '全选' : '取消全选',
                  textStyle: TextStyle(
                      fontSize: FONTSIZE16,
                      fontWeight: FONTWEIGHT400,
                      color: Colors.black),
                  backgroundColor: Colors.transparent,
                  onTap: _selectAllBtnAction,
                ),
                STButton(
                  text: '删除',
                  textStyle: TextStyle(
                      fontSize: FONTSIZE16,
                      fontWeight: FONTWEIGHT400,
                      color: Theme.of(context).primaryColor),
                  onTap: _deletBtnAction,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _selectOneAction(int index) {
    final _model = _lists[index];
    _model.selected = !_model.selected!;
    _selectedMap[_model.id!] = _model.selected!;
    _isSelectAll = _isAllSelected();
    setState(() {});
  }

  void _selectAllBtnAction() {
    _isSelectAll = !_isSelectAll;

    for (var list in _lists) {
      list.selected = _isSelectAll;
      _selectedMap[list.id!] = _isSelectAll;
    }
    setState(() {});
  }

  void _deletBtnAction() {}

  bool _isAllSelected() {
    int _res = 0;
    for (final key in _selectedMap.keys) {
      if (_selectedMap[key] != null && _selectedMap[key]!) {
        _res += 1;
      }
    }
    return _res == _selectedMap.keys.length;
  }
}
