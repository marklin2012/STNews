import 'package:flutter/material.dart';

typedef HeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class ScrollHeader extends StatelessWidget {
  final double maxExtent;
  final double minExtent;
  final HeaderBuilder builder;

  const ScrollHeader(
      {Key? key,
      this.maxExtent = 80,
      this.minExtent = 80,
      required this.builder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _ScrollHeaderDelegate(maxExtent, minExtent, builder),
      pinned: true,
    );
  }
}

class _ScrollHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxE;
  final double minE;
  final HeaderBuilder builder;

  _ScrollHeaderDelegate(this.maxE, this.minE, this.builder);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => maxE;

  @override
  double get minExtent => minE;

  @override
  bool shouldRebuild(covariant _ScrollHeaderDelegate oldDelegate) {
    return maxE != oldDelegate.maxE ||
        minE != oldDelegate.minE ||
        builder != oldDelegate.builder;
  }
}
