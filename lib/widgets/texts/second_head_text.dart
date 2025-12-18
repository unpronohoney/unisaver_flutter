import 'package:flutter/material.dart';

class SecondHeadText extends StatelessWidget {
  final String text;
  const SecondHeadText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}
