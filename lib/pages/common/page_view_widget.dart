import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    this.margin,
  }) : super(key: key);

  final List<String>? pageList;
  final int? currentIndex;
  final double? height;
  final bool isAutoRoll;
  final int autoRollTime;
  final EdgeInsets? margin;

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late List<String> _pageList;
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

    if (widget.isAutoRoll && _pageList.isNotEmpty) {
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
              String? coverImage = _pageList[index % _pageList.length];
              return buildPageViewItem(image: coverImage, index: index);
            },
            itemCount: _pageList.isEmpty ? 0 : 100,
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value % (_pageList.length);
              });
            },
          ),
          if (_pageList.length > 1)
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
    String _image = 'http://via.placeholder.com/500x200';
    if (image != null && image.length > 1) {
      _image = image;
    }
    return Container(
      margin: widget.margin ??
          EdgeInsets.symmetric(horizontal: _horFix, vertical: _verFix),
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
          imageUrl: _image,
          fit: BoxFit.fill,
          placeholder: (context, url) => Container(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
