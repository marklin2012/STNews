import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_photo_view.dart';
import 'package:stnews/utils/hero_tags.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/st_routers.dart';
import 'package:stnews/utils/string+.dart';

const _horFix = 16.0;
const _verFix = 8.0;

class PageViewWidget extends StatefulWidget {
  static const PageViewDebounceKey = 'PageViewDebounceKey';
  const PageViewWidget({
    Key? key,
    this.pageList,
    this.currentIndex,
    this.height,
    this.isAutoRoll = true,
    this.isLooped = true,
    this.autoRollTime = 2,
    this.margin,
    this.decoration,
    this.width,
    this.canShowPhotoView = false,
  }) : super(key: key);

  final List<String>? pageList;
  final int? currentIndex;
  final double? height;
  final double? width;
  final bool isAutoRoll;
  final bool isLooped;
  final int autoRollTime;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;
  final bool canShowPhotoView;

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late List<String> _pageList;
  late List<String> _galleryItems;
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
            duration: Duration(milliseconds: 400), curve: Curves.ease);
      });
    }
    _galleryItems =
        _pageList.map((e) => STString.addPrefixHttp(e) ?? '').toList();
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
    double _otherH = 2 * _verFix;
    if (widget.margin != null) {
      _otherH = widget.margin!.top + widget.margin!.bottom;
    }
    return Container(
      height: _height + _otherH,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              String? coverImage;
              if (widget.isLooped) {
                coverImage = _pageList[index % _pageList.length];
              } else {
                coverImage = _pageList[index];
              }
              return buildPageViewItem(image: coverImage, index: index);
            },
            itemCount: _pageList.isEmpty
                ? 0
                : (widget.isLooped ? 100 : _pageList.length),
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
    final _galleryItem = STString.addPrefixHttp(_image) ?? '';
    return Container(
      margin: widget.margin ??
          EdgeInsets.symmetric(horizontal: _horFix, vertical: _verFix),
      height: _height,
      decoration: widget.decoration ??
          BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (!widget.canShowPhotoView) return;
            STDebounce().start(
              key: PageViewWidget.PageViewDebounceKey,
              func: () {
                STRouters.push(
                  context,
                  NewsPhotoView(
                    galleryItems: _galleryItems,
                    defaultImage: index,
                  ),
                );
              },
              time: 200,
            );
          },
          child: Hero(
            tag: NewsHeroTags.showPhotoImageTag + _galleryItem,
            child: NewsImage.networkImage(
              path: _image,
              width: widget.width ?? MediaQuery.of(context).size.width,
              height: _height,
              borderRadius: BorderRadius.circular(5.0),
              defaultChild: Container(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
