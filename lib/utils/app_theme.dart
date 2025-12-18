import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

enum AppTheme { light, dark }

class AppThemes {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.whiteish,
      secondary: AppColors.gray,
      tertiary: AppColors.grayishBlue,
      primaryFixed: AppColors.blue,
      secondaryFixed: AppColors.darkBlue,
      tertiaryFixed: AppColors.niceBlack,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.niceBlack,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkBlue,
      secondary: AppColors.blue,
      tertiary: AppColors.grayishBlue,
      primaryFixed: AppColors.gray,
      secondaryFixed: AppColors.whiteish,
      tertiaryFixed: AppColors.white,
    ),
  );
}
