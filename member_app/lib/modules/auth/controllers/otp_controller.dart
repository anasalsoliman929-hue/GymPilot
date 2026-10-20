import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final AuthRepository _auth    = Get.find<AuthRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  RxString email       = ''.obs;
  RxBool isNewAccount  = false.obs;
  RxBool isLoading     = false.obs;
  RxInt  seconds       = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      email.value      = args['email']?.toString() ?? '';
      isNewAccount.value = args['isNewAccount'] == true;
    }
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes[0].canRequestFocus) focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    seconds.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value == 0) t.cancel();
      else seconds.value--;
    });
  }

  void onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    final code = otpControllers.map((c) => c.text).join();
    if (code.length == 6) verify();
  }

  Future<void> verify() async {
    final code = otpControllers.map((c) => c.text).join();
    if (code.length < 6) { AppSnackbar.error('enter_otp_6digits'.tr); return; }
    isLoading.value = true;
    try {
      final result = await _auth.verifyOtp(email: email.value, code: code);
      await _storage.saveToken(result.token);
      await _storage.saveUser(result.user.toJson());
      AppSnackbar.success('welcome_user'.trParams({'name': result.user.name}));
      // شاشات التعريف تظهر مرة وحدة بس بعد كل إنشاء حساب جديد،
      // مش عند تسجيل الدخول العادي.
      Get.offAllNamed(isNewAccount.value ? AppRoutes.onboarding : AppRoutes.main);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
      for (final c in otpControllers) c.clear();
      focusNodes[0].requestFocus();
    } catch (_) {
      AppSnackbar.error('error_try_again'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resend() async {
    if (seconds.value > 0) return;
    try {
      await _auth.resendOtp(email: email.value);
      for (final c in otpControllers) c.clear();
      focusNodes[0].requestFocus();
      _startTimer();
      AppSnackbar.success('new_code_sent'.tr);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final c in otpControllers) c.dispose();
    for (final n in focusNodes) n.dispose();
    super.onClose();
  }
}
