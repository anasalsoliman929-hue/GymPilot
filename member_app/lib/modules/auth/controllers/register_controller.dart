import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();

  final nameCtrl     = TextEditingController();
  final emailCtrl    = TextEditingController();
  final phoneCtrl    = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl  = TextEditingController();
  final heightCtrl   = TextEditingController();
  final weightCtrl   = TextEditingController();
  final goalCtrl     = TextEditingController();

  DateTime? dateOfBirth;
  RxString gender           = 'male'.obs;
  RxBool isPasswordHidden   = true.obs;
  RxBool isConfirmHidden    = true.obs;
  RxBool isLoading          = false.obs;
  RxInt  step               = 0.obs;

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirm()  => isConfirmHidden.value  = !isConfirmHidden.value;
  void setGender(String g) => gender.value = g;
  void setDob(DateTime d)  => dateOfBirth = d;
  void nextStep() { if (step.value < 2) step.value++; }
  void goPrev()  { if (step.value > 0)  step.value--; }

  String? validateName(String? v)  => (v == null || v.trim().isEmpty) ? 'enter_full_name'.tr : null;
  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'enter_email'.tr;
    if (!v.contains('@')) return 'invalid_email'.tr;
    return null;
  }
  String? validatePhone(String? v)    => (v == null || v.trim().isEmpty) ? 'enter_phone'.tr : null;
  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'enter_password'.tr;
    if (v.length < 8) return 'password_min_8'.tr;
    return null;
  }
  String? validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'confirm_password'.tr;
    if (v != passwordCtrl.text) return 'passwords_not_match'.tr;
    return null;
  }

  Future<void> register() async {
    if (dateOfBirth == null) { AppSnackbar.error('select_birth_date'.tr); return; }
    isLoading.value = true;
    try {
      final dob = '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2,'0')}-${dateOfBirth!.day.toString().padLeft(2,'0')}';
      final email = await _auth.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: passwordCtrl.text,
        passwordConfirmation: confirmCtrl.text,
        dateOfBirth: dob,
        gender: gender.value,
        height: double.tryParse(heightCtrl.text),
        initialWeight: double.tryParse(weightCtrl.text),
        goal: goalCtrl.text.trim(),
      );
      Get.toNamed(AppRoutes.otp, arguments: {'email': email, 'isNewAccount': true});
    } on ApiException catch (e) {
      // الباك إند بيرجع خطأ "الإيميل مستخدم" لو في حساب أُنشئ سابقاً بنفس
      // الإيميل بس لسا ما انفعّل (المستخدم طلع من التطبيق قبل إدخال كود
      // التحقق). بهاي الحالة منعيد إرسال الكود وننقله لصفحة التحقق مباشرة
      // بدل ما نوقفه بخطأ بدون أي طريق للمتابعة.
      final emailTaken = e.isValidationError &&
          (e.errors?.containsKey('email') ?? false);

      if (emailTaken) {
        final email = emailCtrl.text.trim();
        try {
          await _auth.resendOtp(email: email);
          Get.toNamed(AppRoutes.otp, arguments: {'email': email, 'isNewAccount': true});
          return;
        } catch (_) {
          // الحساب فعلاً مفعّل ومستخدم من قبل شخص آخر — اعرض الخطأ الأصلي
        }
      }
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('unexpected_error_retry'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose(); emailCtrl.dispose(); phoneCtrl.dispose();
    passwordCtrl.dispose(); confirmCtrl.dispose();
    heightCtrl.dispose(); weightCtrl.dispose(); goalCtrl.dispose();
    super.onClose();
  }
}
