import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

BoxDecoration listCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: AppColors.white.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.18),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Container dismissibleBackground() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.red,
      borderRadius: BorderRadius.circular(18),
    ),
    padding: const EdgeInsets.only(right: 24),
    alignment: Alignment.centerRight,
    child: const Icon(Icons.delete, color: AppColors.white, size: 28),
  );
}
