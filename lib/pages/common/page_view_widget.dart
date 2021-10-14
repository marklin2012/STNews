import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/pages/common/color_config.dart';

const _horFix = 16.0;
const _verFix = 8.0;

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({
    Key? key,
    this.pageList,
    this.currentIndex,
    this.height,
    this.isAutoRoll = true,
    this.autoRollTime = 3,
  }) : super(key: key);

  final List<PostModel>? pageList;
  final int? currentIndex;
  final double? height;
  final bool isAutoRoll;
  final int autoRollTime;

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late List<PostModel> _pageList;
  late int _currentIndex;
  late double _height;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _pageList = widget.pageList ?? [];
    _height = widget.height ?? 200;
    _pageController = PageController(initialPage: 0);

    if (widget.isAutoRoll) {
      _timer = new Timer.periodic(new Duration(seconds: widget.autoRollTime),
          (timer) {
        int _temp = _currentIndex;

        _currentIndex = (_temp + 1) % (_pageList.length);

        _pageController.animateToPage(_currentIndex,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
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
    );
  }
}
