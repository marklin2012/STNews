import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/st_routers.dart';

// ignore: must_be_immutable
class AreaCodePage extends StatelessWidget {
  AreaCodePage({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  final void Function(Map<String, String>)? onChanged;

  Map<String, dynamic> _map = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('国家或地区选择'),
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: Icon(
            STIcons.commonly_close,
            color: Colors.black,
          ),
          onTap: () {
            STRouters.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _getAreaCodes(context),
        builder: (context, snap) {
          if (snap.hasError) debugPrint(snap.error.toString());
          List<String> _titles = [];
          for (var item in _map.keys) {
            _titles.add(item);
          }
          List<String> _values = [];
          for (var item in _map.values) {
            _values.add(item.toString());
          }
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                itemCount: _titles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(_titles[index]),
                      trailing: Text('+' + _values[index]),
                      onTap: () {
                        final selectArea = {_titles[index]: _values[index]};
                        if (onChanged != null) onChanged!(selectArea);
                        STRouters.pop(context);
                      });
                }),
          );
        },
      ),
    );
  }

  Future _getAreaCodes(BuildContext context) async {
    await DefaultAssetBundle.of(context)
        .loadString('assets/json/worldcode.json')
        .then((value) {
      _map = json.decode(value);
    });
  }
}
