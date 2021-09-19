import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';

// ignore: must_be_immutable
class PostDetailInheritedWidget extends InheritedWidget {
  late ValueNotifier<PostModel> _valueNotifier;

  ValueNotifier<PostModel> get valueNotifier => _valueNotifier;

  PostDetailInheritedWidget(PostModel postModel, {required Widget child})
      : super(child: child) {
    _valueNotifier = ValueNotifier<PostModel>(postModel);
  }

  static PostDetailInheritedWidget? of(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<PostDetailInheritedWidget>();
    if (element != null) {
      return element.widget as PostDetailInheritedWidget;
    }
  }

  void updateData(PostModel model) {
    _valueNotifier.value = model;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
