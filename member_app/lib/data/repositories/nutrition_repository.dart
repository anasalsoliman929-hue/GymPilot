import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/nutrition_model.dart';

class NutritionRepository {
  final ApiClient _client;
  NutritionRepository(this._client);

  /// GET /member/nutrition-plan
  Future<NutritionPlanModel> getPlan() async {
    final res = await _client.get(ApiConstants.memberNutritionPlan);
    return NutritionPlanModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
