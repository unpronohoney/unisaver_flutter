import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  final String text;
  const HeadText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontFamily: 'MontserratAlternates',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}
