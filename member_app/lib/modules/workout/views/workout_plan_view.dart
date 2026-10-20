import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/workout_model.dart';
import '../controllers/workout_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class WorkoutPlanView extends StatelessWidget {
  const WorkoutPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkoutController>();

    return Scaffold(
      appBar: AppBar(title: Text('full_plan'.tr)),
      body: Obx(() {
        if (c.isLoadingPlan.value) {
          return const AppLoading();
        }
        if (c.planError != null) {
          return AppErrorView(message: c.planError!, onRetry: c.loadPlan);
        }
        final plan = c.plan.value;
        if (plan == null) {
          return AppEmptyState(
              icon: Icons.fitness_center_outlined,
              message: 'no_training_plan_yet'.tr);
        }

        final title        = plan.plan['title']?.toString() ?? '';
        final trainingDays = (plan.plan['training_days'] as List?)
                ?.map((d) => d as int)
                .toList() ?? [];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Plan header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: trainingDays.map((d) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        dayNames[d] ?? '$d',
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 12),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Exercises by day
            ...plan.exercisesByDay.entries.map((entry) {
              final dayNum   = int.tryParse(entry.key) ?? 0;
              final dayName  = dayNames[dayNum] ?? entry.key;
              final exercises = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.borderColor),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  leading: const Icon(Icons.fitness_center,
                      color: AppColors.primary),
                  title: Text(dayName,
                      style: TextStyle(
                          color: context.textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: Text('exercises_count'.trParams({'n': '${exercises.length}'}),
                      style: TextStyle(
                          color: context.textSecondary, fontSize: 12)),
                  iconColor: AppColors.primary,
                  collapsedIconColor: context.textSecondary,
                  children: exercises.map((ex) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.circle,
                        size: 7, color: AppColors.primary),
                    title: Text(ex.name,
                        style: TextStyle(
                            color: context.textPrimary, fontSize: 13)),
                    subtitle: Text(ex.details,
                        style: TextStyle(
                            color: context.textSecondary, fontSize: 11)),
                    trailing: ex.notes != null && ex.notes!.isNotEmpty
                        ? Tooltip(
                            message: ex.notes!,
                            child: const Icon(Icons.info_outline,
                                color: AppColors.primary, size: 16))
                        : null,
                  )).toList(),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}