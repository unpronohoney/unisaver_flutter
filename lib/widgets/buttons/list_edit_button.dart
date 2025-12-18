import 'package:flutter/material.dart';

class ListEditButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ListEditButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(
          context,
        ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      ),
      child: IconButton(
        onPressed: () {
          onPressed();
        },
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.secondaryFixed,
          size: 22,
        ),
      ),
    );
  }
}
