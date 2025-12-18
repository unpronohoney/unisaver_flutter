import 'package:flutter/material.dart';

void showScaffoldMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      content: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  );
}
