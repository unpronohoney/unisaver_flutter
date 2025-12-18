import 'package:flutter/material.dart';

class GreenCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size = 40;
  final Color rippleColor = const Color(0x332196F3);

  const GreenCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: rippleColor,
        onTap: onPressed,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryFixed,
              width: 2.5,
            ),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondaryFixed,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}
