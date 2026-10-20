import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/otp_controller.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<OtpController>(force: true);
    final c = Get.put(OtpController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Back button
              FadeSlideIn(
                child: TapScale(
                  onTap: () => Get.back(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Icon
              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: Center(
                  child: PulseWidget(
                    child: Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
                        ],
                      ),
                      child: const Icon(Icons.mark_email_read_outlined, color: AppColors.primary, size: 42),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Center(
                  child: Text('otp_enter_title'.tr,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 8),

              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: Obx(() => Center(
                      child: Text(
                        'otp_sent_to'.trParams({'email': c.email.value}),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, height: 1.6),
                      ),
                    )),
              ),

              const SizedBox(height: 36),

              // OTP boxes
              FadeSlideIn(
                delay: const Duration(milliseconds: 250),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 46, height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor, width: 2),
                    ),
                    child: TextFormField(
                      controller: c.otpControllers[i],
                      focusNode: c.focusNodes[i],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.w600),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                      onChanged: (v) => c.onDigitChanged(i, v),
                    ),
                  )),
                ),
              ),

              const SizedBox(height: 36),

              // Verify button
              FadeSlideIn(
                delay: const Duration(milliseconds: 320),
                child: Obx(() => PrimaryButton(
                      label: 'otp_confirm'.tr,
                      isLoading: c.isLoading.value,
                      onPressed: c.verify,
                    )),
              ),

              const SizedBox(height: 24),

              // Resend
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: Obx(() => Center(
                      child: c.seconds.value > 0
                          ? Text(
                              'otp_resend_in'.trParams({'seconds': '${c.seconds.value}'}),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13))
                          : TapScale(
                              onTap: c.resend,
                              child: Text('otp_resend'.tr,
                                  style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                    )),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
