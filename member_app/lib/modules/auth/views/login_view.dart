import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/login_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController _c;
  // ✅ formKey يُنشأ مرة واحدة فقط
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _c = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey, // ← هنا بدلاً من c.formKey
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
                            child: Icon(Icons.fitness_center, color: context.textPrimary, size: 42),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text('GymPilot',
                            style: TextStyle(color: context.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('login_subtitle'.tr,
                            style: TextStyle(color: context.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: AppTextField(
                    label: 'email_label'.tr,
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
                        label: 'password_label'.tr,
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
                              color: context.textSecondary,
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
                      child: Text('forgot_password_q'.tr,
                          style: TextStyle(color: AppColors.primary, fontSize: 13)),
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _c.login();
                          }
                        },
                      )),
                ),
                const SizedBox(height: 32),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 440),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('no_account_q'.tr,
                          style: TextStyle(color: context.textSecondary, fontSize: 13)),
                      TapScale(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: Text('create_account'.tr,
                            style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
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