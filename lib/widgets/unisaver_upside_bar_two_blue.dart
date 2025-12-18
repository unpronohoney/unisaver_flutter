import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/blue_rounded_button.dart';
import 'package:unisaver_flutter/widgets/buttons/green_circle_icon_button.dart';

class UnisaverUpsideBarTwoBlue extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onBackUpPressed;
  final VoidCallback onTakeBackDeletePressed;
  final IconData icon;

  const UnisaverUpsideBarTwoBlue({
    super.key,
    required this.icon,
    required this.onHomePressed,
    required this.onBackUpPressed,
    required this.onTakeBackDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          GreenCircleIconButton(icon: icon, onPressed: onHomePressed),
          const Spacer(),
          BlueRoundedButton(
            text: t(context).basaAl,
            onPressed: onBackUpPressed,
          ),
          const Spacer(),
          BlueRoundedButton(
            text: t(context).silmeyiGeriAl,
            onPressed: onTakeBackDeletePressed,
          ),
        ],
      ),
    );
  }
}
