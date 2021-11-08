import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

class SearchHistory extends StatelessWidget {
  static const searchHistoryDebounceKey = 'searchHistoryDebounceKey';
  const SearchHistory({
    Key? key,
    this.historyTap,
    this.cleanTap,
    this.historys,
  }) : super(key: key);

  final List<String>? historys;
  final Function(String key)? historyTap;
  final Function()? cleanTap;

  @override
  Widget build(BuildContext context) {
    if (historys == null || historys!.isEmpty) return Container();
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '历史记录',
                style: NewsTextStyle.style17BoldBlack,
              ),
              STButton.icon(
                backgroundColor: Colors.transparent,
                size: STButtonSize.small,
                icon: Icon(
                  STIcons.commonly_ashcan,
                  color: ColorConfig.textThrColor,
                  size: 15,
                ),
                onTap: _historyClean,
              ),
            ],
          ),
          SizedBox(height: 18),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: historys!.map((e) {
              return GestureDetector(
                onTap: () {
                  _historyAction(e);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConfig.secGrey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(4.0)),
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

  void _historyClean() {
    STDebounce().start(
        key: SearchHistory.searchHistoryDebounceKey,
        func: () {
          if (cleanTap != null) cleanTap!();
        },
        time: 200);
  }

  void _historyAction(String key) {
    if (key.length == 0) {
      return;
    }
    STDebounce().start(
        key: SearchHistory.searchHistoryDebounceKey,
        func: () {
          if (historyTap != null) historyTap!(key);
        },
        time: 200);
  }
}
