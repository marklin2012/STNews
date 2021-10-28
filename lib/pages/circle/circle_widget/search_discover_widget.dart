import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';

class SearchDiscover extends StatefulWidget {
  const SearchDiscover({Key? key}) : super(key: key);

  @override
  _SearchDiscoverState createState() => _SearchDiscoverState();
}

class _SearchDiscoverState extends State<SearchDiscover> {
  List<String> _discovers = [];

  @override
  void initState() {
    super.initState();
    _discovers = [
      '重大发现',
      '重大发现',
      '头条新闻',
      '重大发现',
      '头条新闻',
      '重大发现',
      '头条新闻',
      '重大发现',
      '头条新闻',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '搜索发现',
            style: NewsTextStyle.style17BoldBlack,
          ),
          SizedBox(height: 16),
          Wrap(
            runSpacing: 12,
            spacing: 1,
            children: _discovers.map((e) {
              return InkWell(
                highlightColor: ColorConfig.baseFourBlue,
                onTap: () {},
                child: Container(
                  width: NewsScale.screenW(context) / 2 - 18,
                  child: Text(
                    e,
                    style: NewsTextStyle.style14NormalSecGrey,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
