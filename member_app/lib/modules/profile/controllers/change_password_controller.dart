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

  String? validateCurrent(String? v) =>
      (v == null || v.isEmpty) ? 'current_password_required'.tr : null;

  String? validateNew(String? v) {
    if (v == null || v.isEmpty) return 'new_password_required'.tr;
    if (v.length < 8) return 'must_be_min_8_chars'.tr;
    return null;
  }

  String? validateConfirm(String? v) {
    if (v != newPasswordController.text) return 'passwords_not_match'.tr;
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
      // الباك إند يحذف كل التوكنات بعد تغيير كلمة المرور -> يجب إعادة تسجيل الدخول
      await _storage.clearSession();
      Get.offAllNamed(AppRoutes.login);
      AppSnackbar.success('password_changed_successfully'.tr);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('failed_change_password'.tr);
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
