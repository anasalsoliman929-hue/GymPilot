import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'أدخل البريد الإلكتروني';
    if (!v.contains('@')) return 'بريد غير صالح';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
    return null;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final result = await _auth.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      await _storage.saveToken(result.token);
      await _storage.saveUser(result.user.toJson());

      // كلمة مرور مؤقتة؟ لازم يغيّرها قبل ما يدخل عالتطبيق
      if (result.user.isTempPassword) {
        Get.offAllNamed(AppRoutes.forceChangePassword);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('حدث خطأ، تحقق من الاتصال بالإنترنت');
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
