import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
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
import 'package:stnews/utils/string+.dart';

class SearchCirclePage extends StatefulWidget {
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
    circleSeaProvider.searchHotMoment();
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
                    debounceKey: SearchCirclePage.searchCircleDebounceKey,
                    controller: _searchController,
                    ableOnChanged: false,
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
                        discoverTap: (String discover) {
                          _searchController.text = discover;
                          _search(discover);
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
    final _temp = STString.removeSpace(value);
    _searchValue = _temp;
    // 开始请求
    await circleSeaProvider.searchKey(key: _searchValue);
    // 保存数据
    SharedPref.saveCircleSearchHistory(_searchValue)
        .then((_) => circleSeaProvider.getHistorys());
  }

  void _gotoCircleDetailPage(MomentModel? model) {
    if (model == null) return;
    STDebounce().start(
      key: SearchCirclePage.searchCircleDebounceKey,
      func: () {
        // 去圈子详情页
        STRouters.push(
          context,
          CircleDetailPage(moment: model),
        );
      },
      time: 200,
    );
  }
}
