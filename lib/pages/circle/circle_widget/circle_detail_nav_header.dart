import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/st_routers.dart';

const CircleDetailNavHeaderDebounceKey = 'CircleDetailNavHeaderDebounceKey';

class CircleDetailNavHeader extends StatelessWidget {
  const CircleDetailNavHeader({
    Key? key,
    this.leadingImg,
    this.leadingTitle,
    this.trailing,
  }) : super(key: key);

  final Widget? leadingImg;

  final Widget? leadingTitle;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              STDebounce().start(
                  key: CircleDetailNavHeaderDebounceKey,
                  func: () {
                    STRouters.pop(context);
                  });
            },
            child: Icon(
              STIcons.direction_leftoutlined,
              color: ColorConfig.textFirColor,
            ),
          ),
          if (leadingImg != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: leadingImg!,
            ),
          if (leadingTitle != null) Expanded(child: leadingTitle!),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
