import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

class BlobBackground4 extends StatelessWidget {
  const BlobBackground4({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BlobPainter4(
        isligth: Theme.of(context).brightness == Brightness.light,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class BlobPainter4 extends CustomPainter {
  final bool isligth;
  BlobPainter4({required this.isligth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isligth
          ? AppColors.black.withValues(alpha: 0.1)
          : AppColors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Üstte bir oval blob
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    final paint3 = Paint()
      ..color = isligth
          ? AppColors.black.withValues(alpha: 0.1)
          : AppColors.black.withValues(alpha: 0.25);
    final path3 = Path();

    path3.moveTo(size.width * 0.85, size.height * 0.8);
    path3.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.8),
        radius: 24,
      ),
    );
    canvas.drawPath(path3, paint3);

    // Altta başka bir blob
    final paint2 = Paint()
      ..color = isligth
          ? AppColors.black.withValues(alpha: 0.1)
          : AppColors.black.withValues(alpha: 0.25);

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.82);
    path2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.62,
      size.width * 0.7,
      size.height * 0.83,
    );
    path2.lineTo(size.width * 0.7, size.height * 0.83);

    path2.quadraticBezierTo(
      size.width * 0.77,
      size.height * 0.9,
      size.width,
      size.height * 0.86,
    );

    path2.lineTo(size.width, size.height * 0.9);

    path2.lineTo(size.width, size.height);

    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
