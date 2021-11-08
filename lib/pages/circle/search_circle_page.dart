import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_detail_page.dart';
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

  late TextEditingController _searchController;

  CircleSearchProvider get circleSeaProvider =>
      Provider.of<CircleSearchProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        circleSeaProvider.cleanSearchRecoreds();
      }
    });
    circleSeaProvider.getHistorys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlankPutKeyborad(
        child: Consumer<CircleSearchProvider>(
            builder: (BuildContext context, CircleSearchProvider cirSeaP, _) {
          return Container(
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
                    controller: _searchController,
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
                      SearchHistory(
                        historys: cirSeaP.historys,
                        historyTap: (String history) {
                          _searchController.text = history;
                          _search(history);
                        },
                        cleanTap: () {
                          cirSeaP.cleanHistorys();
                        },
                      ),
                      SearchDiscover(
                        discovers: cirSeaP.seachDiscovers,
                        discoverTap: (MomentModel model) {
                          _gotoCircleDetailPage(model);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 44,
                  bottom: 0,
                  child: cirSeaP.hasRecords
                      ? Container(
                          color: ColorConfig.primaryColor,
                          margin: EdgeInsets.only(left: 16.0, top: 16.0),
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                MomentModel model =
                                    cirSeaP.searchRecords[index];
                                return GestureDetector(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: ColorConfig.fourGrey),
                                      ),
                                    ),
                                    child: NewsRichText(
                                      maxLines: 1,
                                      searchContent: _searchValue,
                                      textContent: model.title,
                                    ),
                                  ),
                                  onTap: () {
                                    // 去详情页
                                    _gotoCircleDetailPage(model);
                                  },
                                );
                              },
                              itemCount: cirSeaP.searchRecords.length,
                            ),
                          ),
                        )
                      : SizedBox(height: 1),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _search(String value) async {
    _searchValue = value;
    // 开始请求
    await circleSeaProvider.searchKey(key: value);
    // 请求成功
    SharedPref.saveCircleSearchHistory(value)
        .then((value) => circleSeaProvider.getHistorys());
  }

  void _gotoCircleDetailPage(MomentModel? model) {
    if (model == null) return;
    // 去圈子详情页
    STRouters.push(
      context,
      CircleDetailPage(moment: model),
    );
  }
}
