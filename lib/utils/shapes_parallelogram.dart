import 'package:flutter/material.dart';
import 'package:stnews/pages/common/color_config.dart';

class ShapeParallelogram extends CustomPainter {
  ShapeParallelogram({Key? key, this.color});

  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint();

    _paint.color = color ?? ColorConfig.baseFourBlue;
    var _path = Path();
    _path.moveTo(2, 0);
    _path.lineTo(18, 0);
    _path.lineTo(16, 4);
    _path.lineTo(0, 4);
    _path.close();
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
