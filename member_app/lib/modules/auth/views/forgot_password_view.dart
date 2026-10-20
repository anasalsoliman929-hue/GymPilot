import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              FadeSlideIn(
                child: TapScale(
                  onTap: () => Get.back(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: context.textPrimary, size: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: Center(
                  child: Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: context.cardColor, shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 42),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Center(
                  child: Text('forgot_password_q'.tr,
                      style: TextStyle(color: context.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),

              const SizedBox(height: 8),

              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: Center(
                  child: Text(
                    'forgot_password_desc'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.textSecondary, fontSize: 13, height: 1.6),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              FadeSlideIn(
                delay: const Duration(milliseconds: 250),
                child: AppTextField(
                  label: 'email_label'.tr,
                  hint: 'name@example.com',
                  prefixIcon: Icons.email_outlined,
                  controller: c.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => c.sendOtp(),
                ),
              ),

              const SizedBox(height: 28),

              FadeSlideIn(
                delay: const Duration(milliseconds: 320),
                child: Obx(() => PrimaryButton(
                      label: 'send_verification_code'.tr,
                      isLoading: c.isLoading.value,
                      onPressed: c.sendOtp,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
