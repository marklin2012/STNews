import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';

class MallHomeMenu extends StatefulWidget {
  const MallHomeMenu({
    Key? key,
    this.height,
    this.menus,
    this.selectedTap,
  }) : super(key: key);

  final double? height;

  final List<String>? menus;

  final Function(String)? selectedTap;

  @override
  State<MallHomeMenu> createState() => _MallHomeMenuState();
}

class _MallHomeMenuState extends State<MallHomeMenu> {
  late double _height;
  late List<String> _menus;
  late List<STMenuDataItem> _items;

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 44.0;
    _menus = widget.menus ?? ['运动', '百货', '时尚', '器械', '配饰'];
    _items = _menus.map((e) => STMenuDataItem(title: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: STMenu(
        type: STMenuType.button,
        items: _items,
        onTap: _menuOnTap,
      ),
    );
  }

  void _menuOnTap(int index) {
    if (widget.selectedTap != null) {
      final selectedString = _items[index].title;
      widget.selectedTap!(selectedString);
    }
  }
}
