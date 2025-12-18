import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  const CommonText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: Theme.of(context).colorScheme.secondaryFixed,
      ),
    );
  }
}
