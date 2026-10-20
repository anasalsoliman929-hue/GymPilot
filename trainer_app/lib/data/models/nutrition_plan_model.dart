/// خطة تغذية يُنشئها المدرب لعضو معيّن
/// GET|POST /trainer/nutrition-plans , GET /trainer/nutrition-plans/{id}
class NutritionPlanModel {
  final int id;
  final int memberId;
  final int trainerId;
  final String title;
  final int targetCalories;
  final bool isActive;
  final int? totalCalories; // مجموع سعرات الوجبات — يظهر بالتفاصيل فقط
  final List<MealModel> meals;

  NutritionPlanModel({
    required this.id,
    required this.memberId,
    required this.trainerId,
    required this.title,
    required this.targetCalories,
    required this.isActive,
    this.totalCalories,
    this.meals = const [],
  });

  factory NutritionPlanModel.fromJson(Map<String, dynamic> json) {
    return NutritionPlanModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      memberId:       int.tryParse(json['member_id']?.toString() ?? '') ?? 0,
      trainerId:      int.tryParse(json['trainer_id']?.toString() ?? '') ?? 0,
      title:          json['title']?.toString() ?? '',
      targetCalories: int.tryParse(json['target_calories']?.toString() ?? '') ?? 0,
      isActive:       json['is_active'] == true,
      totalCalories:  json['total_calories'] != null ? int.tryParse(json['total_calories'].toString()) : null,
      meals: (json['meals'] as List?)
              ?.map((m) => MealModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// وجبة ضمن خطة تغذية
/// POST /trainer/nutrition-plans/{id}/meals , PUT|DELETE /trainer/meals/{id}
class MealModel {
  final int id;
  final int nutritionPlanId;
  final String name;
  final String mealTime; // HH:mm:ss
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String? notes;

  MealModel({
    required this.id,
    required this.nutritionPlanId,
    required this.name,
    required this.mealTime,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    this.notes,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id:              int.tryParse(json['id'].toString()) ?? 0,
      nutritionPlanId: int.tryParse(json['nutrition_plan_id']?.toString() ?? '') ?? 0,
      name:            json['name']?.toString() ?? '',
      mealTime:        json['meal_time']?.toString() ?? '',
      calories:        int.tryParse(json['calories']?.toString() ?? '') ?? 0,
      proteinGrams:    double.tryParse(json['protein_grams']?.toString() ?? '') ?? 0.0,
      carbsGrams:      double.tryParse(json['carbs_grams']?.toString() ?? '') ?? 0.0,
      fatGrams:        double.tryParse(json['fat_grams']?.toString() ?? '') ?? 0.0,
      notes:           json['notes']?.toString(),
    );
  }
}