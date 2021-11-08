import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';

class SearchDiscover extends StatelessWidget {
  static const searchDiscoverDebounceKey = 'searchDiscoverDebounceKey';
  const SearchDiscover({
    Key? key,
    this.discovers,
    this.discoverTap,
  }) : super(key: key);

  final List<MomentModel>? discovers;

  final Function(MomentModel)? discoverTap;

  // [
  //     '重大发现',
  //     '重大发现',
  //     '头条新闻',
  //     '重大发现',
  //     '头条新闻',
  //     '重大发现',
  //     '头条新闻',
  //     '重大发现',
  //     '头条新闻',
  //   ];

  @override
  Widget build(BuildContext context) {
    if (discovers == null || discovers!.isEmpty) return Container();
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
            children: discovers!.map((e) {
              return GestureDetector(
                onTap: () {
                  _discoverAction(e);
                },
                child: Container(
                  width: NewsScale.screenW(context) / 2 - 18,
                  child: Text(
                    e.title ?? '',
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

  void _discoverAction(MomentModel? model) {
    if (model == null) return;

    STDebounce().start(
      key: SearchDiscover.searchDiscoverDebounceKey,
      func: () {
        if (discoverTap != null) discoverTap!(model);
      },
      time: 200,
    );
  }
}
