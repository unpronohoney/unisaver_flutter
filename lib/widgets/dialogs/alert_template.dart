import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';

class AlertTemplate extends StatelessWidget {
  final VoidCallback onDismiss;
  final String title;
  final String exp;
  const AlertTemplate({
    super.key,
    required this.title,
    required this.exp,
    required this.onDismiss,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteish,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.niceBlack,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    exp,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: AppColors.niceBlack,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PurpleButton(
                    text: t(context).tmm,
                    onPressed: () {
                      onDismiss();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
