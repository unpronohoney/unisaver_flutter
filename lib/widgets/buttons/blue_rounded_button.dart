import 'package:flutter/material.dart';

class BlueRoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color rippleColor;

  const BlueRoundedButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.rippleColor = const Color(0x332196F3),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: rippleColor,
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryFixed,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryFixed,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }
}
