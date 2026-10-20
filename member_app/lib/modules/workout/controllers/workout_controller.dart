import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/workout_repository.dart';

class WorkoutController extends GetxController {
  final WorkoutRepository _repository = Get.find<WorkoutRepository>();

  RxBool isLoadingToday = true.obs;
  RxBool isLoadingPlan = true.obs;
  RxInt pendingTopups = 0.obs;
  RxList topups = [].obs;
  final Rx<TodayWorkoutModel?> today = Rx<TodayWorkoutModel?>(null);
  final Rx<WorkoutPlanModel?> plan = Rx<WorkoutPlanModel?>(null);

  String? todayError;
  String? planError;

  @override
  void onInit() {
    super.onInit();
    loadToday();
    loadPlan();
  }

  Future<void> loadToday() async {
    isLoadingToday.value = true;
    todayError = null;
    try {
      today.value = await _repository.getToday();
    } on ApiException catch (e) {
      todayError = e.firstError;
    } catch (_) {
      todayError = 'failed_load_today_workout'.tr;
    } finally {
      isLoadingToday.value = false;
    }
  }

  Future<void> loadPlan() async {
    isLoadingPlan.value = true;
    planError = null;
    try {
      plan.value = await _repository.getPlan();
    } on ApiException catch (e) {
      planError = e.firstError;
    } catch (_) {
      planError = 'failed_load_plan'.tr;
    } finally {
      isLoadingPlan.value = false;
    }
  }

  void refresh() {
    loadToday();
    loadPlan();
  }
}
