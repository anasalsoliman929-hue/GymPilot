import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/register_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RegisterController());
    final step1Key = GlobalKey<FormState>();
    final step2Key = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  TapScale(
                    onTap: () {
                      if (c.step.value > 0) c.goPrev();
                      else Get.back();
                    },
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
                  const SizedBox(width: 12),
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('create_new_account'.tr,
                              style: TextStyle(color: context.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                          Text('step_of_3'.trParams({'n': '${c.step.value + 1}'}),
                              style: TextStyle(color: context.textSecondary, fontSize: 12)),
                        ],
                      )),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Progress bar
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (c.step.value + 1) / 3,
                      minHeight: 5,
                      backgroundColor: context.borderColor,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                )),

            const SizedBox(height: 20),

            // Steps
            Expanded(
              child: Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(begin: const Offset(0.08, 0), end: Offset.zero).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(c.step.value),
                      child: switch (c.step.value) {
                        0 => _StepOne(c: c, formKey: step1Key),
                        1 => _StepTwo(c: c, formKey: step2Key),
                        _ => _StepThree(c: c),
                      },
                    ),
                  )),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Obx(() => PrimaryButton(
                    label: c.step.value == 2 ? 'create_account_button'.tr : 'next_button'.tr,
                    icon: c.step.value == 2 ? Icons.person_add_outlined : Icons.arrow_forward,
                    isLoading: c.isLoading.value,
                    onPressed: () {
                      if (c.step.value == 0) {
                        if (step1Key.currentState?.validate() ?? false) c.nextStep();
                      } else if (c.step.value == 1) {
                        if (step2Key.currentState?.validate() ?? false) c.nextStep();
                      } else {
                        c.register();
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1 ───────────────────────────────────────────────
class _StepOne extends StatelessWidget {
  final RegisterController c;
  final GlobalKey<FormState> formKey;
  const _StepOne({required this.c, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          AppTextField(
            label: 'full_name_label'.tr, hint: 'أحمد محمد',
            prefixIcon: Icons.person_outline,
            controller: c.nameCtrl,
            textInputAction: TextInputAction.next,
            validator: c.validateName,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'email_label'.tr, hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            controller: c.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: c.validateEmail,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'phone_label'.tr, hint: '+963 9XX XXX XXX',
            prefixIcon: Icons.phone_outlined,
            controller: c.phoneCtrl,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: c.validatePhone,
          ),
        ]),
      ),
    );
  }
}

// ─── Step 2 ───────────────────────────────────────────────
class _StepTwo extends StatelessWidget {
  final RegisterController c;
  final GlobalKey<FormState> formKey;
  const _StepTwo({required this.c, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          Obx(() => AppTextField(
                label: 'password_label'.tr, hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                controller: c.passwordCtrl,
                obscure: c.isPasswordHidden.value,
                textInputAction: TextInputAction.next,
                validator: c.validatePassword,
                suffix: IconButton(
                  onPressed: c.togglePassword,
                  icon: Icon(c.isPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                      color: context.textSecondary),
                ),
              )),
          const SizedBox(height: 14),
          Obx(() => AppTextField(
                label: 'confirm_password_label'.tr, hint: '••••••••',
                prefixIcon: Icons.lock,
                controller: c.confirmCtrl,
                obscure: c.isConfirmHidden.value,
                textInputAction: TextInputAction.done,
                validator: c.validateConfirm,
                suffix: IconButton(
                  onPressed: c.toggleConfirm,
                  icon: Icon(c.isConfirmHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                      color: context.textSecondary),
                ),
              )),
        ]),
      ),
    );
  }
}

// ─── Step 3 ───────────────────────────────────────────────
class _StepThree extends StatefulWidget {
  final RegisterController c;
  const _StepThree({required this.c});
  @override
  State<_StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<_StepThree> {
  DateTime? _dob;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender
          Text('gender_label'.tr, style: TextStyle(color: context.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: ['male', 'female'].map((g) {
                  final sel = c.gender.value == g;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => c.setGender(g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(left: g == 'female' ? 6 : 0, right: g == 'male' ? 6 : 0),
                        height: 48,
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : context.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sel ? AppColors.primary : context.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(g == 'male' ? Icons.male : Icons.female,
                                color: sel ? context.textPrimary : context.textSecondary),
                            const SizedBox(width: 6),
                            Text(g == 'male' ? 'male'.tr : 'female'.tr,
                                style: TextStyle(
                                    color: sel ? context.textPrimary : context.textSecondary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

          const SizedBox(height: 14),

          // Date of Birth
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1940),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: AppColors.primary, surface: context.cardColor),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) { setState(() => _dob = picked); c.setDob(picked); }
            },
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.cardColor, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Row(children: [
                Icon(Icons.calendar_today_outlined, color: context.textSecondary, size: 20),
                const SizedBox(width: 12),
                Text(
                  _dob != null ? '${_dob!.day}/${_dob!.month}/${_dob!.year}' : 'birth_date_required'.tr,
                  style: TextStyle(color: _dob != null ? context.textPrimary : context.textSecondary),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 14),

          Row(children: [
            Expanded(child: AppTextField(
              label: 'height_cm'.tr, hint: '175',
              prefixIcon: Icons.height,
              controller: c.heightCtrl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            )),
            const SizedBox(width: 12),
            Expanded(child: AppTextField(
              label: 'weight_kg'.tr, hint: '70',
              prefixIcon: Icons.monitor_weight_outlined,
              controller: c.weightCtrl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            )),
          ]),

          const SizedBox(height: 14),

          AppTextField(
            label: 'fitness_goal_optional'.tr,
            hint: 'fitness_goal_hint'.tr,
            prefixIcon: Icons.flag_outlined,
            controller: c.goalCtrl,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
