import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final ApiClient _client;
  WorkoutRepository(this._client);

  /// GET /member/training-plan/today
  Future<TodayWorkoutModel> getToday() async {
    final res = await _client.get(ApiConstants.memberTrainingToday);
    return TodayWorkoutModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /member/training-plan
  Future<WorkoutPlanModel> getPlan() async {
    final res = await _client.get(ApiConstants.memberTrainingPlan);
    return WorkoutPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
