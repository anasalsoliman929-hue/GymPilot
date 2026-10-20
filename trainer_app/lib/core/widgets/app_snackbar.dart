import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: AppColors.success,
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      isDismissible: true,
    ));
  }

  static void error(String message) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: AppColors.danger,
      duration: const Duration(seconds: 4),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      isDismissible: true,
    ));
  }

  static void info(String message) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: AppColors.info,
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: Colors.white),
      isDismissible: true,
    ));
  }
}
