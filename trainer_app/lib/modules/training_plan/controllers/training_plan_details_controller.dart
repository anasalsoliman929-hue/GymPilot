import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/training_plan_model.dart';
import '../../../data/repositories/training_plan_repository.dart';

class TrainingPlanDetailsController extends GetxController {
  final TrainingPlanRepository _repo = Get.find<TrainingPlanRepository>();

  late final int planId;
  RxBool isLoading = true.obs;
  String? error;
  Rx<TrainingPlanModel?> plan = Rx<TrainingPlanModel?>(null);

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
      error = 'تعذّر تحميل خطة التمرين';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExercise(int exerciseId) async {
    try {
      await _repo.deleteExercise(exerciseId);
      AppSnackbar.success('تم حذف التمرين');
      load();
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر حذف التمرين');
    }
  }
}
