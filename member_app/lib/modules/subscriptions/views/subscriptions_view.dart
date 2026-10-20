import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/subscriptions_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SubscriptionsController());

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text('create_subscription'.tr),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const AppLoading();
        }
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }
        return RefreshIndicator(
          onRefresh: c.load,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Subscription Types ──────────────────────
              FadeSlideIn(
                child: SectionLabel('subscription_type_label'.tr),
              ),
              const SizedBox(height: 10),
              Obx(() => Column(
                children: c.subscriptionTypes.map((t) {
                  final id       = t['id'] as int;
                  final name     = t['name']?.toString() ?? '';
                  final months   = t['duration_months'] as int? ?? 1;
                  final price    = (t['final_price'] as num?)?.toDouble() ?? 0;
                  final isSelected = c.selectedTypeId.value == id;
                  return FadeSlideIn(
                    child: GestureDetector(
                      onTap: () => c.selectedTypeId.value = id,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : context.borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(
                                  color: AppColors.primary.withOpacity(0.15),
                                  blurRadius: 12, spreadRadius: 2)]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: TextStyle(
                                          color: context.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                  Text('months_value'.trParams({'n': '$months'}),
                                      style: TextStyle(
                                          color: context.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                            Text(
                              price > 0 ? 'price_syp'.trParams({'n': '${price.toInt()}'}) : 'free_label'.tr,
                              style: TextStyle(
                                color: isSelected ? AppColors.primary : context.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : context.borderColor,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(Icons.check, color: context.textPrimary, size: 13)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // ─── Periods ─────────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: SectionLabel('time_period_label'.tr),
              ),
              const SizedBox(height: 10),
              Obx(() => Column(
                children: c.periods.map((p) {
                  final id         = p['id'] as int;
                  // final name       = p['name']?.toString() ?? '';
                  final start      = p['start_time']?.toString().substring(0, 5) ?? '';
                  final end        = p['end_time']?.toString().substring(0, 5) ?? '';
                  final trainer    = p['trainer']?['name']?.toString() ?? '';
                  final spotsLeft  = p['spots_left'] as int? ?? 0;
                  final isSelected = c.selectedPeriodId.value == id;
                  return FadeSlideIn(
                    child: GestureDetector(
                      onTap: spotsLeft > 0
                          ? () => c.selectedPeriodId.value = id
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : context.borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$start - $end',
                                      style: TextStyle(
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.w600)),
                                  Text('trainer_prefix'.trParams({'name': trainer}),
                                      style: TextStyle(
                                          color: context.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: spotsLeft > 0
                                    ? const Color(0xFF1a3a1a)
                                    : const Color(0xFF3a1a1a),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                spotsLeft > 0
                                    ? 'spots_left'.trParams({'n': '$spotsLeft'})
                                    : 'full_label'.tr,
                                style: TextStyle(
                                  color: spotsLeft > 0
                                      ? AppColors.success
                                      : AppColors.danger,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // ─── Training Type ────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: SectionLabel('training_type_label'.tr),
              ),
              const SizedBox(height: 10),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: SubscriptionsController.trainingTypes.entries.map((e) {
                  final isSelected = c.trainingType.value == e.key;
                  return GestureDetector(
                    onTap: () => c.trainingType.value = e.key,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : context.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : context.borderColor,
                        ),
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          color: isSelected ? context.textPrimary : context.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // ─── Training Days ────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 220),
                child: SectionLabel('training_days_label'.tr),
              ),
              const SizedBox(height: 10),
              Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: SubscriptionsController.dayNames.entries.map((e) {
                  final isSelected = c.trainingDays.contains(e.key);
                  return GestureDetector(
                    onTap: () => c.toggleDay(e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : context.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : context.borderColor,
                        ),
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          color: isSelected ? context.textPrimary : context.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // ─── Start Date ───────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 280),
                child: SectionLabel('start_date_label'.tr),
              ),
              const SizedBox(height: 10),
              Obx(() => GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppColors.primary,
                          surface: context.cardColor,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    c.startDate.value =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        c.startDate.value.isEmpty
                            ? 'choose_start_date'.tr
                            : c.startDate.value,
                        style: TextStyle(color: context.textPrimary),
                      ),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 28),

              // ─── Subscribe Button ─────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 340),
                child: Obx(() => PrimaryButton(
                      label: 'create_subscription_button'.tr,
                      icon: Icons.check_circle_outline,
                      isLoading: c.isSubscribing.value,
                      onPressed: c.subscribe,
                    )),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}