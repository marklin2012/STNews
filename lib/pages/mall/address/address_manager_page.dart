import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/address/address_new_edit_page.dart';
import 'package:stnews/pages/mall/address/widgets/address_cell.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class AddressManagePage extends StatefulWidget {
  const AddressManagePage({
    Key? key,
    this.canChoosed = false,
    this.choosedTap,
  }) : super(key: key);

  final bool canChoosed;

  final Function(AddressModel)? choosedTap;

  @override
  State<AddressManagePage> createState() => _AddressManagePageState();
}

class _AddressManagePageState extends State<AddressManagePage> {
  late ValueNotifier<bool> _manageNoti;
  late int addressNumbers;
  late List<int> _selected;

  @override
  void initState() {
    super.initState();
    final _isManaged = false;
    _manageNoti = ValueNotifier(_isManaged);
    addressNumbers = 4;
    _selected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        title: Text('收货地址'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _manageNoti,
            builder: (context, bool value, _) {
              return STButton(
                text: value ? '完成' : '管理',
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.fromLTRB(16, 9, 16, 10),
                textStyle: NewsTextStyle.style17NormalBlack,
                onTap: _toggleManaged,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            _buildStack(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ValueListenableBuilder(
      valueListenable: _manageNoti,
      builder: (context, bool isManaged, _) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final isSelected = _selected.contains(index);
            return AddressCell(
              isManaged: isManaged,
              isSelected: isSelected,
              selectedTap: () {
                _toggleOneSelected(!isSelected, index);
              },
              editTap: () {
                STRouters.push(context, AddressNewEditPage());
              },
              canChoosedTap: () {
                if (widget.canChoosed) {
                  // 选择某一项为收货地址
                  STRouters.pop(context);
                  if (widget.choosedTap == null) return;
                  widget.choosedTap!(AddressModel());
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 8,
              color: Colors.transparent,
            );
          },
          itemCount: addressNumbers,
        );
      },
    );
  }

  Widget _buildStack() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder(
        valueListenable: _manageNoti,
        builder: (context, bool value, _) {
          if (!value) {
            return Container(
              margin: EdgeInsets.only(bottom: 40),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: STButton(
                text: '+新建地址',
                textStyle: NewsTextStyle.style18BoldWhite,
                mainAxisSize: MainAxisSize.max,
                padding: EdgeInsets.symmetric(vertical: 6.0),
                onTap: () {
                  // 跳转到新建地址
                  STRouters.push(context, AddressNewEditPage());
                },
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  STButton(
                    text: '全选',
                    backgroundColor: Colors.transparent,
                    icon: _buildIcon(),
                    textStyle: NewsTextStyle.style16NormalBlack,
                    padding: EdgeInsets.zero,
                    onTap: () {
                      _toggleAllSelected(_selected.length == addressNumbers);
                    },
                  ),
                  STButton(
                    text: '删除',
                    textStyle: NewsTextStyle.style16NormalWhite,
                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 3),
                    radius: 4.0,
                    onTap: () {},
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildIcon() {
    if (_selected.length == 0) {
      return Icon(
        Icons.check_box_outline_blank,
        color: ColorConfig.textThrColor,
      );
    } else if (_selected.length > 0 && _selected.length == addressNumbers) {
      return Icon(
        Icons.check_box,
        color: ColorConfig.baseFirBule,
      );
    } else {
      return Icon(
        Icons.indeterminate_check_box,
        color: ColorConfig.baseFirBule,
      );
    }
  }

  void _toggleManaged() {
    _manageNoti.value = !_manageNoti.value;
  }

  void _toggleAllSelected(bool isAllSelected) {
    _selected = [];
    if (!isAllSelected) {
      for (int i = 0; i < addressNumbers; i++) {
        _selected.add(i);
      }
    }
    setState(() {});
  }

  void _toggleOneSelected(bool selected, int index) {
    if (selected) {
      if (!_selected.contains(index)) {
        _selected.add(index);
      }
    } else {
      if (_selected.contains(index)) {
        _selected.remove(index);
      }
    }
    setState(() {});
  }
}
