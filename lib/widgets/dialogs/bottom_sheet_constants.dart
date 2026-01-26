import 'package:flutter/material.dart';

BoxDecoration bottomSheetDecoration(BuildContext context) => BoxDecoration(
  color: Theme.of(context).colorScheme.primary,
  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, -6),
    ),
  ],
);

Widget bottomSheetHandler(BuildContext context) => Center(
  child: Container(
    width: 40,
    height: 5,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.tertiaryFixed.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(100),
    ),
    margin: const EdgeInsets.only(bottom: 16),
  ),
);

Text bottomSheetTitle(BuildContext context, String title) => Text(
  title,
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'MontserratAlternates',
    color: Theme.of(context).colorScheme.tertiaryFixed,
  ),
);

Text bottomSheetDescription(BuildContext context, String description) => Text(
  description,
  style: TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    color: Theme.of(context).colorScheme.secondaryFixed,
  ),
);
