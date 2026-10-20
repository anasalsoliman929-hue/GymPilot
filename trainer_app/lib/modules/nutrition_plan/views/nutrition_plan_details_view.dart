import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../data/models/nutrition_plan_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/nutrition_plan_details_controller.dart';

class NutritionPlanDetailsView extends StatelessWidget {
  const NutritionPlanDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<NutritionPlanDetailsController>(force: true);
    final c = Get.put(NutritionPlanDetailsController());

    return Scaffold(
      appBar: AppBar(title: Text('nutrition_plan'.tr)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final added = await Get.toNamed(
            AppRoutes.mealForm,
            arguments: {'planId': c.planId, 'meal': null},
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

        final totalCalories = plan.totalCalories ??
            plan.meals.fold<int>(0, (sum, m) => sum + m.calories);

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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          MiniStat(value: '${plan.targetCalories}', label: 'target_per_day'.tr),
                          const SizedBox(width: 24),
                          MiniStat(value: '$totalCalories', label: 'meals_total'.tr),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: SectionLabel('meals'.tr),
              ),
              if (plan.meals.isEmpty)
                AppEmptyState(
                  message: 'no_meals_yet'.tr,
                  icon: Icons.restaurant_menu,
                )
              else
                ...plan.meals.asMap().entries.map((e) {
                  final meal = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FadeSlideIn(
                      delay: Duration(milliseconds: 40 * e.key),
                      child: _MealCard(
                        meal: meal,
                        onEdit: () async {
                          final updated = await Get.toNamed(
                            AppRoutes.mealForm,
                            arguments: {'planId': c.planId, 'meal': meal},
                          );
                          if (updated == true) c.load();
                        },
                        onDelete: () => _confirmDelete(context, c, meal),
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

  void _confirmDelete(BuildContext context, NutritionPlanDetailsController c, MealModel meal) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_meal'.tr),
        content: Text('delete_meal_confirm'.trParams({'name': meal.name})),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              c.deleteMeal(meal.id);
            },
            child: Text('delete'.tr, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _MealCard({required this.meal, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final time = meal.mealTime.length >= 5 ? meal.mealTime.substring(0, 5) : meal.mealTime;
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
            child: const Icon(Icons.restaurant_menu, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(meal.name,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                    ),
                    Text(time, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'meal_macros'.trParams({'cal': '${meal.calories}', 'protein': meal.proteinGrams.toStringAsFixed(0), 'carbs': meal.carbsGrams.toStringAsFixed(0), 'fat': meal.fatGrams.toStringAsFixed(0)}),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                ),
                if (meal.notes != null && meal.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(meal.notes!,
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
