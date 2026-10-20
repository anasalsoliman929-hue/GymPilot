import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/api_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_colors_context.dart';

class UpdateDialog {
  UpdateDialog._();

  /// يعرض حوار تحديث. إذا [forced] كان true لا يمكن إغلاقه إلا بالضغط على تحديث.
  static Future<void> show({required bool forced, String? message}) {
    return Get.dialog(
      PopScope(
        canPop: !forced,
        child: AlertDialog(
          backgroundColor: Get.context!.cardColor,
          icon: const Icon(Icons.system_update_alt, color: AppColors.primary, size: 36),
          title: Text(
            forced ? 'update_required_title'.tr : 'update_available_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.context!.textPrimary),
          ),
          content: Text(
            (message != null && message.isNotEmpty)
                ? message
                : (forced ? 'update_required_message'.tr : 'update_available_message'.tr),
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.context!.textSecondary),
          ),
          actions: [
            if (!forced)
              TextButton(
                onPressed: () => Get.back(),
                child: Text('later'.tr),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _openStore,
              child: Text('update_now'.tr),
            ),
          ],
        ),
      ),
      barrierDismissible: !forced,
    );
  }

  static Future<void> _openStore() async {
    final url = Platform.isIOS ? AppStrings.iosStoreUrl : AppStrings.androidStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
