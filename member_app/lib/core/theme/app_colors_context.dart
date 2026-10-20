import 'package:flutter/material.dart';
import 'app_colors.dart';


extension AppColorsContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor   => isDarkMode ? AppColors.darkCard   : AppColors.lightCard;
  Color get bgColor     => isDarkMode ? AppColors.darkBg     : AppColors.lightBg;
  Color get borderColor => isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

  
  Color get textPrimary   => isDarkMode ? AppColors.textDark          : AppColors.textLight;

  Color get textSecondary => isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
}
