import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../routes/app_routes.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WelcomeController());

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return const AppLoading(itemCount: 3);
          }

          final gym = c.gymInfo.value;

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                const Spacer(),

                // ─── شعار/أيقونة الصالة ─────────────────────
                FadeSlideIn(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.fitness_center,
                        color: context.textPrimary, size: 48),
                  ),
                ),

                const SizedBox(height: 24),

                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    gym?.name ?? 'GymPilot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800),
                  ),
                ),

                if (gym?.address != null && gym!.address!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 140),
                    child: _InfoLine(icon: Icons.location_on_outlined, text: gym.address!),
                  ),
                ],

                if (gym?.phone != null && gym!.phone!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 170),
                    child: _InfoLine(icon: Icons.phone_outlined, text: gym.phone!),
                  ),
                ],

                if (gym?.minAge != null) ...[
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: _InfoLine(
                      icon: Icons.badge_outlined,
                      text: 'min_age_label'.trParams({'n': '${gym!.minAge}'}),
                    ),
                  ),
                ],

                const Spacer(flex: 2),

                // ─── زر تسجيل الدخول ─────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 260),
                  child: PrimaryButton(
                    label: 'login_button'.tr,
                    icon: Icons.login,
                    onPressed: () => Get.offAllNamed(AppRoutes.login),
                  ),
                ),

                const SizedBox(height: 12),

                // ─── رابط إنشاء حساب جديد ─────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.register),
                    child: Text('create_new_account'.tr,
                        style: TextStyle(color: context.textSecondary)),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.textSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.textSecondary, fontSize: 13)),
        ),
      ],
    );
  }
}
