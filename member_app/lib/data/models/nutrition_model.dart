class NutritionPlanModel {
  final int id;
  final String title;
  final int? targetCalories;
  final int? totalCalories;
  final bool isActive;
  final List<MealModel> meals;

  NutritionPlanModel({
    required this.id,
    required this.title,
    this.targetCalories,
    this.totalCalories,
    required this.isActive,
    required this.meals,
  });

  factory NutritionPlanModel.fromJson(Map<String, dynamic> json) {
    final plan  = json['plan'] as Map<String, dynamic>? ?? json;
    final meals = json['meals'] as List? ?? [];
    return NutritionPlanModel(
      id:             plan['id'] as int? ?? 0,
      title:          plan['title']?.toString() ?? '',
      targetCalories: plan['target_calories'] as int?,
      totalCalories:  json['total_calories'] as int?,
      isActive:       plan['is_active'] == true,
      meals: meals
          .map((m) => MealModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MealModel {
  final int id;
  final String name;       // الباك إند يرجع name وليس meal_type
  final String? mealTime;
  final int? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final String? notes;

  MealModel({
    required this.id,
    required this.name,
    this.mealTime,
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.notes,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id:           json['id'] as int,
      name:         json['name']?.toString() ?? '',
      mealTime:     json['meal_time']?.toString(),
      calories:     json['calories'] as int?,
      proteinGrams: double.tryParse(json['protein_grams']?.toString() ?? ''),
      carbsGrams:   double.tryParse(json['carbs_grams']?.toString() ?? ''),
      fatGrams:     double.tryParse(json['fat_grams']?.toString() ?? ''),
      notes:        json['notes']?.toString(),
    );
  }
}