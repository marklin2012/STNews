import 'package:flutter/material.dart';
import 'package:saturn/utils/include.dart';
import 'package:stnews/pages/common/color_config.dart';

class ShoppingSelectIcon extends StatelessWidget {
  const ShoppingSelectIcon({
    Key? key,
    this.selected = false,
    this.selectedTap,
    this.margin,
    this.padding,
    this.internalDiameter = 12,
    this.externalDiameter = 24,
    this.activeColor,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  final bool selected;

  final Function(bool)? selectedTap;

  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double internalDiameter; // 内径
  final double externalDiameter; // 外径
  final Color? activeColor; // 内部颜色
  final Color? backgroundColor; // 背景颜色
  final Color? borderColor; // 边框颜色

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedTap == null) return;
        STDebounce().start(
          key: '_shoppingSelectIconDebounceKey',
          func: () {
            selectedTap!(!selected);
          },
          time: 200,
        );
      },
      child: Container(
        margin: margin,
        padding: padding,
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    if (selected) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: externalDiameter,
            width: externalDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? ColorConfig.baseFirBule,
            ),
          ),
          Container(
            height: internalDiameter,
            width: internalDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeColor ?? ColorConfig.primaryColor,
            ),
          )
        ],
      );
    } else {
      return Container(
        height: externalDiameter,
        width: externalDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? ColorConfig.textThrColor),
        ),
      );
    }
  }
}
