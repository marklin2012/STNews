import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_search_header.dart';
import 'package:stnews/pages/mall/stores/stores_category_page.dart';
import 'package:stnews/pages/mall/stores/stores_customer_page.dart';
import 'package:stnews/pages/mall/stores/stores_grid_view_page.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  late int _currentPageIndex;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.index ?? 0;
    _controller = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 44, bottom: 49),
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  StoresGridViewPage(),
                  StoresCategoryPage(),
                  StoresCustomerPage(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 49,
                child: STMenu(
                  type: STMenuType.label,
                  initIndex: _currentPageIndex,
                  backgroundColor: ColorConfig.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  items: [
                    STMenuDataItem(
                      title: '店铺',
                      icon: STIcons.label_drill_outline,
                      fontSize: 11,
                    ),
                    STMenuDataItem(
                      title: '宝贝分类',
                      icon: STIcons.label_grade_outline,
                      fontSize: 11,
                    ),
                    STMenuDataItem(
                      title: '客服',
                      icon: STIcons.commonly_customerservice_outline,
                      fontSize: 11,
                    ),
                  ],
                  onTap: (int index) {
                    _currentPageIndex = index;
                    _controller.jumpToPage(_currentPageIndex);
                    setState(() {});
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 44,
              child: _currentPageIndex == 2
                  ? _buildCustomerNavHeader()
                  : NewsSearchHeader(
                      placeholder: '搜索店铺内宝贝',
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerNavHeader() {
    return Container(
      height: 44,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              STRouters.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 13.0),
              child: Icon(
                STIcons.direction_leftoutlined,
                color: ColorConfig.textFirColor,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            'Baby Star旗舰店',
            style: NewsTextStyle.style16BoldBlack,
          ),
        ],
      ),
    );
  }
}
