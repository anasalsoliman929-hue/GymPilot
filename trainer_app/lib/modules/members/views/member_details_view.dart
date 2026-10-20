import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/member_details_controller.dart';

class MemberDetailsView extends StatelessWidget {
  const MemberDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<MemberDetailsController>(force: true);
    final c = Get.put(MemberDetailsController());

    return Scaffold(
      appBar: AppBar(title: Text('member_details_title'.tr)),
      body: Obx(() {
        if (c.isLoading.value) return const AppLoading();
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }
        final m = c.member.value;
        if (m == null) return AppEmptyState(message: 'member_not_found'.tr);

        final sub = m.activeSubscription;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Header ────────────────────────────────
              FadeSlideIn(
                child: GradientCard(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.name,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            if (m.user?.phone != null)
                              Text(m.user!.phone!,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            if (m.user?.email != null)
                              Text(m.user!.email,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (m.isVerified)
                        const Icon(Icons.verified, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Basic info ─────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: SurfaceCard(
                  child: Column(
                    children: [
                      _InfoRow(label: 'gender'.tr, value: genderLabel(m.gender)),
                      _InfoRow(label: 'goal'.tr, value: m.height != null ? '${m.height} cm' : '—'),
                      _InfoRow(label: 'height'.tr, value: m.height != null ? '${m.height} cm' : '—'),
                      _InfoRow(label: 'initial_weight'.tr, value: m.initialWeight != null ? '${m.initialWeight} kg' : '—'),
                      if (m.medicalNotes != null && m.medicalNotes!.isNotEmpty)
                        _InfoRow(label: 'medical_notes'.tr, value: m.medicalNotes!),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Subscription ───────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
child: SectionLabel('subscription'.tr),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: sub == null
                    ? AppEmptyState(message: 'no_active_subscription'.tr, icon: Icons.card_membership_outlined)
                    : SurfaceCard(
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'type'.tr,
                              value: sub.subscriptionType?.name ?? sub.trainingType,
                            ),
                            _InfoRow(
                                label: 'status'.tr,
                                value: sub.status == 'active' ? 'active'.tr : sub.status),
                            _InfoRow(label: 'from'.tr, value: formatDate(sub.startDate)),
                            _InfoRow(label: 'to'.tr, value: formatDate(sub.endDate)),
                            _InfoRow(label: 'training_days'.tr, value: weekDaysLabel(sub.trainingDays)),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // ─── Training plan ──────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
child: SectionLabel('training_plan'.tr),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: m.activeTrainingPlan == null
                    ? SurfaceCard(
                        child: Column(
                          children: [
                            Icon(Icons.fitness_center, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 32),
                            const SizedBox(height: 8),
                            Text('no_active_training_plan'.tr,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: 'create_training_plan'.tr,
                              icon: Icons.add,
                              onPressed: () => Get.toNamed(AppRoutes.trainingPlanCreate, arguments: m.id),
                            ),
                          ],
                        ),
                      )
                    : SurfaceCard(
                        onTap: () => Get.toNamed(AppRoutes.trainingPlanDetails, arguments: m.activeTrainingPlan!.id),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.fitness_center, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.activeTrainingPlan!.title,
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                                  Text(weekDaysLabel(m.activeTrainingPlan!.trainingDays),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // ─── Nutrition plan ──────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
child: SectionLabel('nutrition_plan'.tr),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: m.activeNutritionPlan == null
                    ? SurfaceCard(
                        child: Column(
                          children: [
                            Icon(Icons.restaurant_menu, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 32),
                            const SizedBox(height: 8),
                            Text('no_active_nutrition_plan'.tr,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: 'create_nutrition_plan'.tr,
                              icon: Icons.add,
                              onPressed: () => Get.toNamed(AppRoutes.nutritionPlanCreate, arguments: m.id),
                            ),
                          ],
                        ),
                      )
                    : SurfaceCard(
                        onTap: () =>
                            Get.toNamed(AppRoutes.nutritionPlanDetails, arguments: m.activeNutritionPlan!.id),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.restaurant_menu, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.activeNutritionPlan!.title,
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                                  Text('cal_per_day'.trParams({'count': '${m.activeNutritionPlan!.targetCalories}'}),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.left,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
