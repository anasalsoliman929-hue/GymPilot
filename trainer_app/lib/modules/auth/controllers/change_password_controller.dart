import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ChangePasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool hideCurrent = true.obs;
  RxBool hideNew = true.obs;
  RxBool hideConfirm = true.obs;

  /// true لما يكون هاد تغيير إجباري لكلمة مرور مؤقتة (بدون إمكانية الرجوع)
  bool isForced = false;

  @override
  void onInit() {
    super.onInit();
    isForced = Get.arguments == true;
  }

  String? validateCurrent(String? v) =>
      (v == null || v.isEmpty) ? 'current_password_required'.tr : null;

  String? validateNew(String? v) {
    if (v == null || v.isEmpty) return 'new_password_required'.tr;
    if (v.length < 8) return 'min_8_chars'.tr;
    return null;
  }

  String? validateConfirm(String? v) {
    if (v != newPasswordController.text) return 'passwords_dont_match'.tr;
    return null;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      await _authRepository.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      // الباك إند يحذف كل التوكنات بعد التغيير -> لازم إعادة تسجيل الدخول
      await _storage.clearSession();
      AppSnackbar.success('password_changed_relogin'.tr);
      Get.offAllNamed(AppRoutes.login);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('password_change_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
