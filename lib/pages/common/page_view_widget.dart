import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

const _horFix = 16.0;
const _verFix = 8.0;

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({
    Key? key,
    this.pageList,
    this.currentIndex,
    this.height,
  }) : super(key: key);

  final List<PostModel>? pageList;
  final int? currentIndex;
  final double? height;

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late List<PostModel> _pageList;
  late int _currentIndex;
  late double _height;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _pageList = widget.pageList ?? [];
    _height = widget.height ?? 200;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) {
              PostModel _model = _pageList[index % _pageList.length];
              return buildPageViewItem(image: _model.coverImage, index: index);
            },
            itemCount: 100,
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value % (_pageList.length);
              });
            },
          ),
          Positioned(
            bottom: _horFix,
            left: 0,
            right: 0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pageList.length,
                  (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? ColorConfig.primaryColor
                            : Color.fromRGBO(255, 255, 255, 0.3),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageViewItem({String? image, required int index}) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: _horFix, vertical: _verFix),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Expanded(
        flex: 1,
        child: Container(
          color: Colors.yellow,
          child: CachedNetworkImage(
            width: 500,
            height: 200,
            imageUrl: image ?? 'http://via.placeholder.com/500x200',
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
