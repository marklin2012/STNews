import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stnews/pages/circle/circle_widget/search_discover_widget.dart';
import 'package:stnews/pages/circle/circle_widget/search_history_widget.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_rich_text.dart';
import 'package:stnews/pages/common/news_search_header.dart';
import 'package:stnews/providers/circle_search_provider.dart';
import 'package:stnews/utils/shared_pref.dart';
import 'package:stnews/utils/st_routers.dart';

class SearchCirclePage extends StatefulWidget {
  static const searchCircleHeroTag = 'searchCircleHeroTag';
  static const searchCircleDebounceKey = '_searchCircleDebounceKey';
  const SearchCirclePage({Key? key}) : super(key: key);

  @override
  _SearchCirclePageState createState() => _SearchCirclePageState();
}

class _SearchCirclePageState extends State<SearchCirclePage> {
  String _searchValue = '';

  CircleSearchProvider get circleSeaProvider =>
      Provider.of<CircleSearchProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPutKeyborad(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 44,
                child: NewsSearchHeader(
                  heroTag: SearchCirclePage.searchCircleHeroTag,
                  debounceKey: SearchCirclePage.searchCircleDebounceKey,
                  searchTap: (String value) {
                    _search(value);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 44,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchHistory(),
                    SearchDiscover(),
                  ],
                ),
              ),
              Consumer<CircleSearchProvider>(builder:
                  (BuildContext context, CircleSearchProvider cirSeaP, _) {
                return Positioned(
                  left: 0,
                  right: 0,
                  top: 44,
                  bottom: 0,
                  child: cirSeaP.hasResults
                      ? Container(
                          color: ColorConfig.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: NewsRichText(
                                    maxLines: 1,
                                    searchContent: _searchValue,
                                    textContent: cirSeaP.seaResults[index],
                                  ),
                                ),
                                onTap: () {},
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                height: 1,
                                color: ColorConfig.fourGrey,
                              );
                            },
                            itemCount: cirSeaP.seaResults.length,
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _search(String value) {
    _searchValue = value;
    // 开始请求

    // 请求成功
    SharedPref.saveCircleSearchHistory(value)
        .then((value) => circleSeaProvider.getHistorys());
  }
}
