import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/nutrition_model.dart';
import '../controllers/nutrition_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NutritionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('nutrition_title'.tr),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const AppLoading();
        }
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }
        final plan = c.plan.value;
        if (plan == null) {
          return AppEmptyState(
            icon: Icons.restaurant_menu_outlined,
            message: 'no_nutrition_plan'.tr,
          );
        }
        return RefreshIndicator(
          onRefresh: c.load,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Header ─────────────────────────────────
              FadeSlideIn(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.title,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('meals_per_day'.trParams({'n': '${plan.meals.length}'}),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (plan.targetCalories != null)
                        Column(
                          children: [
                            AnimatedCounter(
                              end: plan.targetCalories!,
                              style: TextStyle(
                                  color: context.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            Text('calories_per_day_short'.tr,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Meals ───────────────────────────────────
              ...plan.meals.asMap().entries.map((e) => FadeSlideIn(
                    delay: Duration(milliseconds: 80 + e.key * 70),
                    child: _MealTile(meal: e.value),
                  )),

              const SizedBox(height: 16),

              // ─── Macros summary ──────────────────────────
              if (plan.meals.any((m) =>
                  m.proteinGrams != null ||
                  m.carbsGrams != null ||
                  m.fatGrams != null))
                FadeSlideIn(
                  delay: Duration(milliseconds: 80 + plan.meals.length * 70),
                  child: _MacrosSummary(meals: plan.meals),
                ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Meal Tile ────────────────────────────────────────────────
class _MealTile extends StatelessWidget {
  final MealModel meal;
  const _MealTile({required this.meal});

  String _formatTime(String? t) {
    if (t == null) return '';
    return t.substring(0, 5); // HH:MM
  }

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor),
        ),
        child: ExpansionTile(
          leading: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.restaurant,
                color: AppColors.primary, size: 20),
          ),
          title: Text(meal.name,
              style: TextStyle(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          subtitle: Text(
            [
              if (meal.mealTime != null) _formatTime(meal.mealTime),
              if (meal.calories != null) 'calories_value'.trParams({'n': '${meal.calories}'}),
            ].join(' • '),
            style: TextStyle(color: context.textSecondary, fontSize: 11),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: context.textSecondary,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notes
                  if (meal.notes != null && meal.notes!.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(meal.notes!,
                              style: const TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  // Macros
                  if (meal.proteinGrams != null ||
                      meal.carbsGrams != null ||
                      meal.fatGrams != null)
                    Wrap(
                      spacing: 8, runSpacing: 6,
                      children: [
                        if (meal.proteinGrams != null)
                          _MacroChip(
                              label: 'protein'.tr,
                              value: 'grams_value'.trParams({'n': '${meal.proteinGrams!.toInt()}'}),
                              color: const Color(0xFF4ECDC4)),
                        if (meal.carbsGrams != null)
                          _MacroChip(
                              label: 'carbs'.tr,
                              value: 'grams_value'.trParams({'n': '${meal.carbsGrams!.toInt()}'}),
                              color: const Color(0xFFFFB347)),
                        if (meal.fatGrams != null)
                          _MacroChip(
                              label: 'fat'.tr,
                              value: 'grams_value'.trParams({'n': '${meal.fatGrams!.toInt()}'}),
                              color: const Color(0xFFFF6B6B)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Macro Chip ───────────────────────────────────────────────
class _MacroChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MacroChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text('$label: $value',
          style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

// ─── Macros Summary ───────────────────────────────────────────
class _MacrosSummary extends StatelessWidget {
  final List<MealModel> meals;
  const _MacrosSummary({required this.meals});

  @override
  Widget build(BuildContext context) {
    final totalProtein =
        meals.fold<double>(0, (s, m) => s + (m.proteinGrams ?? 0));
    final totalCarbs =
        meals.fold<double>(0, (s, m) => s + (m.carbsGrams ?? 0));
    final totalFat =
        meals.fold<double>(0, (s, m) => s + (m.fatGrams ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('total_macros'.tr,
              style: TextStyle(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroBar(
                  label: 'protein'.tr,
                  value: totalProtein,
                  color: const Color(0xFF4ECDC4)),
              _MacroBar(
                  label: 'carbs'.tr,
                  value: totalCarbs,
                  color: const Color(0xFFFFB347)),
              _MacroBar(
                  label: 'fat'.tr,
                  value: totalFat,
                  color: const Color(0xFFFF6B6B)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _MacroBar(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('grams_value'.trParams({'n': '${value.toInt()}'}),
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(color: context.textSecondary, fontSize: 12)),
      ],
    );
  }
}