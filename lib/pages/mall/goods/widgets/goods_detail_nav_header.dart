import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/page_view_widget.dart';
import 'package:stnews/utils/image+.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/utils+.dart';

const goodsDetailNavHeight = 360.0;

class GoodsDetailNavHeader extends StatelessWidget {
  const GoodsDetailNavHeader({
    Key? key,
    required this.offset,
    this.navLists,
    this.imageLists,
    this.navSelectedTap,
  }) : super(key: key);
  final double offset;
  final List<String>? navLists;
  final List<String>? imageLists;
  final Function(int)? navSelectedTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConfig.fourGrey,
      child: Stack(
        children: [
          _getContent(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _getNavLists(),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _getNavPop(context),
          ),
        ],
      ),
    );
  }

  Widget _getNavPop(BuildContext context) {
    return Container(
      height: 44.0,
      child: NewsPopBtn.popBtn(context),
    );
  }

  Widget _getNavLists() {
    return Opacity(
      opacity: offset / goodsDetailNavHeight,
      child: Container(
        height: 44.0,
        alignment: Alignment.center,
        color: ColorConfig.primaryColor,
        child: GoodsDetailNavMenu(
          selectedTap: (int index) {
            if (navSelectedTap == null) return;
            navSelectedTap!(index);
          },
        ),
      ),
    );
  }

  Widget _getContent() {
    if (imageLists != null && imageLists!.length != 0) {
      return PageViewWidget(
        height: 360,
        isLooped: false,
        canShowPhotoView: true,
        margin: EdgeInsets.zero,
        pageList: imageLists,
        decoration: BoxDecoration(
          color: ColorConfig.primaryColor,
        ),
      );
    }
    return Container(
      height: 360,
      color: ColorConfig.baseFourBlue,
      child: Center(
        child: NewsImage.defaultCircle(height: 160),
      ),
    );
  }
}

class GoodsDetailNavMenu extends StatefulWidget {
  const GoodsDetailNavMenu({
    Key? key,
    this.titleLists,
    this.current = 0,
    this.selectedTap,
  }) : super(key: key);

  final List<String>? titleLists;

  final int current;

  final Function(int)? selectedTap;

  @override
  State<GoodsDetailNavMenu> createState() => _GoodsDetailNavMenuState();
}

class _GoodsDetailNavMenuState extends State<GoodsDetailNavMenu> {
  late int _current;
  late List<String> _titleLists;
  late ValueNotifier<int> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _titleLists = widget.titleLists ?? ['宝贝', '评价', '详情'];
    _current = widget.current % _titleLists.length;
    _valueNotifier = ValueNotifier(_current);
  }

  @override
  Widget build(BuildContext context) {
    final _listsW = <Widget>[];
    for (int i = 0; i < _titleLists.length; i++) {
      final _widget = Padding(
        padding: EdgeInsets.only(right: i == _titleLists.length - 1 ? 0 : 12),
        child: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, int value, _) {
            return GestureDetector(
              onTap: () {
                _selectedTap(i);
              },
              child: Text(
                _titleLists[i],
                style: i == value
                    ? NewsTextStyle.style18BoldBlack
                    : NewsTextStyle.style17NormalSecGrey,
              ),
            );
          },
        ),
      );
      _listsW.add(_widget);
    }
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _listsW,
      ),
    );
  }

  void _selectedTap(int index) {
    if (_valueNotifier.value != index) {
      _valueNotifier.value = index;
      if (widget.selectedTap == null) return;
      widget.selectedTap!(index);
    }
  }
}
