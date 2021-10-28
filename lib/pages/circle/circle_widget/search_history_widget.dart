import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/providers/circle_search_provider.dart';
import 'package:stnews/utils/news_text_style.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  CircleSearchProvider get circleSearchProvider =>
      Provider.of<CircleSearchProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    circleSearchProvider.getHistorys();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CircleSearchProvider>(
        builder: (BuildContext context, CircleSearchProvider circleSeaP, _) {
      return Container(
        padding: EdgeInsets.fromLTRB(16, 24, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  onTap: () {
                    circleSeaP.cleanHistorys();
                  },
                ),
              ],
            ),
            SizedBox(height: 18),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: circleSeaP.historys.map((e) {
                return Container(
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
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
