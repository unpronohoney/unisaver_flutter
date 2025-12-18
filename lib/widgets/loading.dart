import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unisaver_flutter/constants/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SizedBox(
            child: Center(
              child: Container(
                width: 144,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.white
                      : AppColors.gray,
                ),
                child: Lottie.asset('assets/unisaver_loading.json'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
