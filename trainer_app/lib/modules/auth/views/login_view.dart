import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController _c;

  @override
  void initState() {
    super.initState();
    Get.delete<LoginController>(force: true);
    _c = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Center(
                    child: Column(
                      children: [
                        PulseWidget(
                          child: Container(
                            width: 84, height: 84,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 24, spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.sports_gymnastics, color: Colors.white, size: 42),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text('GymPilot Trainer',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 26, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('login_subtitle'.tr,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: AppTextField(
                    label: 'email'.tr,
                    hint: 'name@example.com',
                    prefixIcon: Icons.email_outlined,
                    controller: _c.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _c.validateEmail,
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 280),
                  child: Obx(() => AppTextField(
                        label: 'password'.tr,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        controller: _c.passwordController,
                        obscure: _c.isPasswordHidden.value,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _c.login(),
                        validator: _c.validatePassword,
                        suffix: IconButton(
                          onPressed: _c.togglePassword,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _c.isPasswordHidden.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              key: ValueKey(_c.isPasswordHidden.value),
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )),
                ),
                const SizedBox(height: 8),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 320),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                      child: Text('forgot_password'.tr,
                          style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 380),
                  child: Obx(() => PrimaryButton(
                        label: 'login_button'.tr,
                        icon: Icons.login,
                        isLoading: _c.isLoading.value,
                        onPressed: _c.login,
                      )),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 440),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'first_login_notice'.tr,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
