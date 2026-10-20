import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      AppSnackbar.error('أدخل بريداً إلكترونياً صالحاً');
      return;
    }
    isLoading.value = true;
    try {
      await _auth.forgotPassword(email: email);
      Get.toNamed(AppRoutes.otp, arguments: {'email': email});
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('حدث خطأ، تحقق من البريد الإلكتروني');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
