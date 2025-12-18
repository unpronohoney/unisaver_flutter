import 'package:flutter/material.dart';

class PurpleButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  const PurpleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  State<PurpleButton> createState() => _PurpleButtonState();
}

class _PurpleButtonState extends State<PurpleButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        width: widget.width,
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryFixed,
          borderRadius: BorderRadius.circular(20),
          border: pressed
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondaryFixed,
                    width: 4,
                  ),
                  right: BorderSide(
                    color: Theme.of(context).colorScheme.secondaryFixed,
                    width: 4,
                  ),
                ),
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
