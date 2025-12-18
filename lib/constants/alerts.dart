import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';

void showAlert(BuildContext context, String title, String desc) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: AppColors.whiteish,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'MontserratAlternates',
            color: AppColors.blue,
            fontSize: 24,
          ),
        ),
        content: Text(
          desc,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: AppColors.niceBlack,
            fontSize: 16,
          ),
        ),
        actions: [
          PurpleButton(
            onPressed: () => Navigator.pop(context),
            text: t(context).ok,
          ),
        ],
      );
    },
  );
}
