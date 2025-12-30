
import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    double radius = 15;
    double tailWidth = 10;
    double tailHeight = 10;

    // Balonun gövdesi (Yuvarlatılmış dikdörtgen)
    path.addRRect(RRect.fromLTRBR(
        0, 0, size.width, size.height - tailHeight, Radius.circular(radius)));

    // Kuyruk (Üçgen)
    path.moveTo(size.width / 2 - tailWidth, size.height - tailHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + tailWidth, size.height - tailHeight);
    path.close();

    // Gölgeyi çiziyoruz (Elevation etkisi)
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.5), 4.0, true);

    // Balonun kendisini çiziyoruz
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}