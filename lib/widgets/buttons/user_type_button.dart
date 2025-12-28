import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

class UserTypeButton extends StatefulWidget {
  final String imagePath; // PNG path
  final String title;
  final String description;
  final VoidCallback onPressed;
  final double? width;

  const UserTypeButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onPressed,
    this.width,
  });

  @override
  State<UserTypeButton> createState() => _UserTypeButtonState();
}

class _UserTypeButtonState extends State<UserTypeButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primaryFixed,
          borderRadius: BorderRadius.circular(20),
          border: pressed
              ? null
              : Border(
                  bottom: BorderSide(color: colors.secondaryFixed, width: 4),
                  right: BorderSide(color: colors.secondaryFixed, width: 4),
                ),
        ),
        child: Row(
          children: [
            // PNG ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.whiteish.withValues(alpha: 0.5)
                    : AppColors.niceBlack.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(width: 14),

            // TEXTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
