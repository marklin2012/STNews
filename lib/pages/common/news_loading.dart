import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';

class LoadingBase {
  static OverlayEntry show(
    BuildContext context, {
    Widget? content,
    bool touchable = false,
    double minWidth = 146,
    double minHeight = 50,
  }) {
    final OverlayEntry entry = OverlayEntry(builder: (context) {
      final HitTestBehavior behavior =
          touchable ? HitTestBehavior.deferToChild : HitTestBehavior.opaque;
      return GestureDetector(
        behavior: behavior,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: const Alignment(0, 0),
          color: Colors.transparent,
          child: Container(
            height: minHeight,
            width: minWidth,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: ColorConfig.shadeThrColor,
            ),
            child: content,
          ),
        ),
      );
    });
    Overlay.of(context)?.insert(entry);
    return entry;
  }
}

// ignore: avoid_classes_with_only_static_members
class NewsLoading {
  static OverlayEntry? _currentLoading;
  static void start(
    BuildContext context,
  ) {
    _currentLoading?.remove();

    _currentLoading = LoadingBase.show(
      context,
      content: content(),
      minHeight: 100,
      minWidth: 100,
    );
  }

  static void stop() {
    _currentLoading?.remove();
    _currentLoading = null;
  }

  static Widget content() {
    return STLoading(
      alwaysLoading: true,
      icon: Icon(
        STIcons.status_loading,
        size: 40,
        color: ColorConfig.primaryColor,
      ),
      text: '',
    );
  }
}
