import 'dart:io';

import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/update_dialog.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/public_repository.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final forceUpdate = await _checkAppVersion();
    // إذا كان التحديث إجبارياً نوقف المستخدم هون ولا ننتقل لأي شاشة أخرى
    if (forceUpdate) return;

    final storage = Get.find<StorageService>();
    final token = storage.getToken();
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }

  /// يتحقق من إصدار التطبيق مقابل الباك إند (لا يحتاج توكن)
  /// يرجع true إذا كان التحديث إجبارياً (لوقف تدفق الملاحة الطبيعي)
  Future<bool> _checkAppVersion() async {
    try {
      final repo = Get.find<PublicRepository>();
      final platform = Platform.isIOS ? 'ios' : 'android';
      final result = await repo.checkAppVersion(
        platform: platform,
        version: AppStrings.appVersion,
      );

      if (result.forceUpdate || result.updateRequired) {
        await UpdateDialog.show(forced: true, message: result.message);
        return true;
      }

      if (result.updateAvailable) {
        // غير إجباري — نعرضه ونكمل الملاحة الطبيعية بعده
        await UpdateDialog.show(forced: false, message: result.message);
      }
      return false;
    } catch (_) {
      // فشل التحقق (مثلاً لا يوجد إنترنت) لا يجب أن يمنع المستخدم من استخدام التطبيق
      return false;
    }
  }
}
