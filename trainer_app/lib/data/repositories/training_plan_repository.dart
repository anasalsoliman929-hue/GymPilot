import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/training_plan_model.dart';

class TrainingPlanRepository {
  final ApiClient _client;
  TrainingPlanRepository(this._client);

  /// POST /trainer/training-plans — إنشاء خطة وربطها بعضو
  Future<TrainingPlanModel> createPlan({
    required int memberId,
    required String title,
    required List<int> trainingDays,
  }) async {
    final res = await _client.post(ApiConstants.trainerTrainingPlans, data: {
      'member_id': memberId,
      'title': title,
      'training_days': trainingDays,
    });
    return TrainingPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /trainer/training-plans/{id}
  Future<TrainingPlanModel> getPlan(int id) async {
    final res = await _client.get(ApiConstants.trainerTrainingPlanDetails(id));
    return TrainingPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /trainer/training-plans/{planId}/exercises
  Future<ExerciseModel> addExercise({
    required int planId,
    required String name,
    int? equipmentId,
    required int dayOfWeek,
    required int sets,
    required int reps,
    required int restSeconds,
    String? notes,
  }) async {
    final res = await _client.post(
      ApiConstants.trainerTrainingPlanExercises(planId),
      data: {
        'name': name,
        if (equipmentId != null) 'equipment_id': equipmentId,
        'day_of_week': dayOfWeek,
        'sets': sets,
        'reps': reps,
        'rest_seconds': restSeconds,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return ExerciseModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// PUT /trainer/exercises/{id}
  Future<ExerciseModel> updateExercise({
    required int exerciseId,
    String? name,
    int? equipmentId,
    int? dayOfWeek,
    int? sets,
    int? reps,
    int? restSeconds,
    String? notes,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (equipmentId != null) body['equipment_id'] = equipmentId;
    if (dayOfWeek != null) body['day_of_week'] = dayOfWeek;
    if (sets != null) body['sets'] = sets;
    if (reps != null) body['reps'] = reps;
    if (restSeconds != null) body['rest_seconds'] = restSeconds;
    if (notes != null) body['notes'] = notes;

    final res = await _client.put(ApiConstants.trainerExercise(exerciseId), data: body);
    return ExerciseModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// DELETE /trainer/exercises/{id}
  Future<void> deleteExercise(int exerciseId) async {
    await _client.delete(ApiConstants.trainerExercise(exerciseId));
  }
}
