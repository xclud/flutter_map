import 'package:flutter/material.dart';

class TwilightPainter extends CustomPainter {
  TwilightPainter(this.border);
  List<Offset> border;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1;

    for (int i = 1; i < border.length - 2; i++) {
      var p1 = border[i];
      var p2 = border[i + 1];

      canvas.drawLine(p1, p2, paint);
    }

    final path = Path();

    path.moveTo(border[0].dx, border[0].dy);

    for (int i = 1; i < border.length; i++) {
      var p1 = border[i];

      path.lineTo(p1.dx, p1.dy);
    }

    paint.style = PaintingStyle.fill;
    paint.color = Colors.black26;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TwilightPainter oldDelegate) =>
      oldDelegate.border != border;
}
