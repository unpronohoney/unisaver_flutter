import 'package:flutter/material.dart';

class RecommendedButtonWrapper extends StatelessWidget {
  final Widget child;
  final bool showCursor;
  final String message;

  const RecommendedButtonWrapper({
    super.key,
    required this.child,
    required this.showCursor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        child,

        if (showCursor)
          Positioned(top: -36, child: _CursorBubble(message: message)),
      ],
    );
  }
}

class _CursorBubble extends StatelessWidget {
  final String message;

  const _CursorBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
