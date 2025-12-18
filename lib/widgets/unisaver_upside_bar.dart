import 'package:flutter/material.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/blue_rounded_button.dart';
import 'package:unisaver_flutter/widgets/buttons/green_circle_icon_button.dart';

class UnisaverUpsideBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onRefreshPressed;
  final IconData icon;
  final bool isrightbuttonappear;

  const UnisaverUpsideBar({
    super.key,
    required this.icon,
    required this.onHomePressed,
    required this.onRefreshPressed,
    required this.isrightbuttonappear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          GreenCircleIconButton(icon: icon, onPressed: onHomePressed),
          const Spacer(),
          if (isrightbuttonappear)
            BlueRoundedButton(
              text: t(context).refresh,
              onPressed: onRefreshPressed,
            ),
        ],
      ),
    );
  }
}
