import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../data/models/training_plan_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/training_plan_details_controller.dart';

class TrainingPlanDetailsView extends StatelessWidget {
  const TrainingPlanDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<TrainingPlanDetailsController>(force: true);
    final c = Get.put(TrainingPlanDetailsController());

    return Scaffold(
      appBar: AppBar(title: Text('training_plan'.tr)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final added = await Get.toNamed(
            AppRoutes.exerciseForm,
            arguments: {'planId': c.planId, 'exercise': null},
          );
          if (added == true) c.load();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (c.isLoading.value) return const AppLoading();
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }
        final plan = c.plan.value;
        if (plan == null) return AppEmptyState(message: 'plan_not_found'.tr);

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FadeSlideIn(
                child: GradientCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.title,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(weekDaysLabel(plan.trainingDays),
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(plan.isActive ? 'plan_active'.tr : 'plan_inactive'.tr,
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: SectionLabel('exercises'.tr),
              ),
              if (plan.exercises.isEmpty)
                AppEmptyState(
                  message: 'no_exercises_yet'.tr,
                  icon: Icons.fitness_center,
                )
              else
                ...plan.exercises.asMap().entries.map((e) {
                  final ex = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FadeSlideIn(
                      delay: Duration(milliseconds: 40 * e.key),
                      child: _ExerciseCard(
                        exercise: ex,
                        onEdit: () async {
                          final updated = await Get.toNamed(
                            AppRoutes.exerciseForm,
                            arguments: {'planId': c.planId, 'exercise': ex},
                          );
                          if (updated == true) c.load();
                        },
                        onDelete: () => _confirmDelete(context, c, ex),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, TrainingPlanDetailsController c, ExerciseModel ex) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_exercise'.tr),
        content: Text('delete_exercise_confirm'.trParams({'name': ex.name})),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              c.deleteExercise(ex.id);
            },
            child: Text('delete'.tr, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ExerciseCard({required this.exercise, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(exercise.name,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  '${kWeekDays[exercise.dayOfWeek] ?? ''} • ${exercise.sets}×${exercise.reps} • ' + 'rest_seconds'.trParams({'seconds': '${exercise.restSeconds}'}),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                ),
                if (exercise.equipment != null)
                  Text(exercise.equipment!.name,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                if (exercise.notes != null && exercise.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(exercise.notes!,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
