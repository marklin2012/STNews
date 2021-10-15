import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';

class PersonHomeHeader extends StatelessWidget {
  const PersonHomeHeader({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final Widget? leading;

  final Widget? title;

  final Widget? trailing;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 7, 16, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              highlightColor: ColorConfig.baseFirBule,
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (leading != null) leading!,
                  if (leading != null) SizedBox(width: 12.0),
                  if (title != null) title!,
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
