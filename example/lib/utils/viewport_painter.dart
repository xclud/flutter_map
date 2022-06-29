import 'package:flutter/material.dart';

class ViewportPainter extends CustomPainter {
  ViewportPainter(this.viewport);
  final Rect viewport;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1;

    canvas.drawRect(viewport, paint);
  }

  @override
  bool shouldRepaint(covariant ViewportPainter oldDelegate) =>
      oldDelegate.viewport != viewport;
}
