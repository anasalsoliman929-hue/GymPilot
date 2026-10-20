import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/push_notification_service.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'enter_email'.tr;
    if (!v.contains('@')) return 'invalid_email'.tr;
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'enter_password'.tr;
    if (v.length < 6) return 'password_too_short'.tr;
    return null;
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final result = await _auth.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!result.user.isMember) {
        AppSnackbar.error('هذا الحساب غير مخصص لتطبيق الأعضاء');
        return;
      }

      await _storage.saveToken(result.token);
      await _storage.saveUser(result.user.toJson());
      // Get.find<PushNotificationService>().init();
      Get.find<PushNotificationService>().registerTokenAfterLogin();
      Get.offAllNamed(AppRoutes.main);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (e) {
      AppSnackbar.error('connection_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
