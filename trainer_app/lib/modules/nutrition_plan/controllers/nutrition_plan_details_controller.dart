import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/nutrition_plan_model.dart';
import '../../../data/repositories/nutrition_repository.dart';

class NutritionPlanDetailsController extends GetxController {
  final NutritionRepository _repo = Get.find<NutritionRepository>();

  late final int planId;
  RxBool isLoading = true.obs;
  String? error;
  Rx<NutritionPlanModel?> plan = Rx<NutritionPlanModel?>(null);

  @override
  void onInit() {
    super.onInit();
    planId = Get.arguments as int;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      plan.value = await _repo.getPlan(planId);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'تعذّر تحميل خطة التغذية';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMeal(int mealId) async {
    try {
      await _repo.deleteMeal(mealId);
      AppSnackbar.success('تم حذف الوجبة');
      load();
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر حذف الوجبة');
    }
  }
}
