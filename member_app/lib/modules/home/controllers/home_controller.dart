import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../data/models/progress_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/nutrition_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/repositories/workout_repository.dart';

class HomeController extends GetxController {
  final WorkoutRepository   _workoutRepo    = Get.find<WorkoutRepository>();
  final NutritionRepository _nutritionRepo  = Get.find<NutritionRepository>();
  final ProgressRepository  _progressRepo   = Get.find<ProgressRepository>();
  final MemberRepository    _memberRepo     = Get.find<MemberRepository>();
  final StorageService      _storage        = Get.find<StorageService>();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  RxBool isLoading = true.obs;

  final Rx<TodayWorkoutModel?>  todayWorkout  = Rx<TodayWorkoutModel?>(null);
  final Rx<NutritionPlanModel?> nutritionPlan = Rx<NutritionPlanModel?>(null);
  final Rx<ProgressEntryModel?> latestProgress = Rx<ProgressEntryModel?>(null);
  final Rx<Map<String, dynamic>?> activeSubscription = Rx<Map<String, dynamic>?>(null);

  String? todayWorkoutError;
  String? nutritionError;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    loadDashboard();
  }

  void _loadUser() {
    final json = _storage.user;
    if (json != null) currentUser.value = UserModel.fromJson(json);
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    todayWorkoutError = null;
    nutritionError = null;

    await Future.wait([
      _loadTodayWorkout(),
      _loadNutrition(),
      _loadLatestProgress(),
      _loadActiveSubscription(),
    ]);

    isLoading.value = false;
  }

  Future<void> _loadTodayWorkout() async {
    try {
      todayWorkout.value = await _workoutRepo.getToday();
    } on ApiException catch (e) {
      todayWorkoutError = e.firstError;
      todayWorkout.value = null;
    } catch (_) {
      todayWorkoutError = 'failed_load_today_workout'.tr;
    }
  }

  Future<void> _loadNutrition() async {
    try {
      nutritionPlan.value = await _nutritionRepo.getPlan();
    } on ApiException catch (e) {
      nutritionError = e.firstError;
      nutritionPlan.value = null;
    } catch (_) {
      nutritionError = 'failed_load_nutrition_plan'.tr;
    }
  }

  Future<void> _loadLatestProgress() async {
    try {
      final history = await _progressRepo.getHistory(filter: 'all');
      if (history.records.isNotEmpty) {
        latestProgress.value = history.records.first;
      }
    } catch (_) {
      latestProgress.value = null;
    }
  }

  Future<void> _loadActiveSubscription() async {
    try {
      activeSubscription.value = await _memberRepo.getActiveSubscription();
    } catch (_) {
      activeSubscription.value = null;
    }
  }
}
