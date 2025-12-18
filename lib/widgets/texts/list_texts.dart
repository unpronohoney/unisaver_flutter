import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

Text listTitle(BuildContext context, String text) {
  final bool isligth = Theme.of(context).brightness == Brightness.light;
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: isligth ? AppColors.darkBlue : AppColors.white,
    ),
  );
}

Text listSubtitle(BuildContext context, String text) {
  final bool isligth = Theme.of(context).brightness == Brightness.light;
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      color: isligth ? AppColors.blue : AppColors.whiteish,
    ),
  );
}
