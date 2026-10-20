import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/nutrition_plan_model.dart';

class NutritionRepository {
  final ApiClient _client;
  NutritionRepository(this._client);

  /// POST /trainer/nutrition-plans
  Future<NutritionPlanModel> createPlan({
    required int memberId,
    required String title,
    required int targetCalories,
  }) async {
    final res = await _client.post(ApiConstants.trainerNutritionPlans, data: {
      'member_id': memberId,
      'title': title,
      'target_calories': targetCalories,
    });
    return NutritionPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /trainer/nutrition-plans/{id}
  Future<NutritionPlanModel> getPlan(int id) async {
    final res = await _client.get(ApiConstants.trainerNutritionPlanDetails(id));
    return NutritionPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /trainer/nutrition-plans/{planId}/meals
  Future<MealModel> addMeal({
    required int planId,
    required String name,
    required String mealTime, // "08:00"
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? notes,
  }) async {
    final res = await _client.post(
      ApiConstants.trainerNutritionPlanMeals(planId),
      data: {
        'name': name,
        'meal_time': mealTime,
        'calories': calories,
        'protein_grams': protein,
        'carbs_grams': carbs,
        'fat_grams': fat,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return MealModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// PUT /trainer/meals/{id}
  Future<MealModel> updateMeal({
    required int mealId,
    String? name,
    String? mealTime,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? notes,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (mealTime != null) body['meal_time'] = mealTime;
    if (calories != null) body['calories'] = calories;
    if (protein != null) body['protein_grams'] = protein;
    if (carbs != null) body['carbs_grams'] = carbs;
    if (fat != null) body['fat_grams'] = fat;
    if (notes != null) body['notes'] = notes;

    final res = await _client.put(ApiConstants.trainerMeal(mealId), data: body);
    return MealModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// DELETE /trainer/meals/{id}
  Future<void> deleteMeal(int mealId) async {
    await _client.delete(ApiConstants.trainerMeal(mealId));
  }
}
