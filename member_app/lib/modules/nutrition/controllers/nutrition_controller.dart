import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../data/repositories/nutrition_repository.dart';

class NutritionController extends GetxController {
  final NutritionRepository _repository = Get.find<NutritionRepository>();

  RxBool isLoading = true.obs;
  final Rx<NutritionPlanModel?> plan = Rx<NutritionPlanModel?>(null);
  String? error;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      plan.value = await _repository.getPlan();
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_nutrition_plan'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
