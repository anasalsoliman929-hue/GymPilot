import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final json = _storage.user;
    if (json != null) user.value = UserModel.fromJson(json);
  }

  void openQrCode() => Get.toNamed(AppRoutes.qrCode);

  void openChangePassword() => Get.toNamed(AppRoutes.changePassword);

  void openSettings() => Get.toNamed(AppRoutes.settings);

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('logout_title'.tr),
        content: Text('logout_confirm_msg'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text('cancel'.tr)),
          TextButton(onPressed: () => Get.back(result: true), child: Text('logout_title'.tr)),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
    } catch (_) {
      // نسجّل الخروج محلياً بكل الحالات حتى لو فشل الطلب (مثلاً لا يوجد اتصال)
    } finally {
      await _storage.clearSession();
      isLoggingOut.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
