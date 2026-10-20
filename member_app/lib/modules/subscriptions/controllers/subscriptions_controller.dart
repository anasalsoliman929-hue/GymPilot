import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../modules/main/controllers/main_controller.dart';

class SubscriptionsController extends GetxController {
  final ApiClient _client = Get.find<ApiClient>();

  RxBool isLoading       = true.obs;
  RxBool isSubscribing   = false.obs;
  RxList subscriptionTypes = [].obs;
  RxList periods           = [].obs;
  String? error;

  // اختيارات المستخدم
  RxInt  selectedTypeId   = 0.obs;
  RxInt  selectedPeriodId = 0.obs;
  RxString trainingType   = 'bodybuilding'.obs;
  RxList<int> trainingDays = <int>[].obs;
  RxString startDate      = ''.obs;

  // أسماء أيام الأسبوع
  static Map<int, String> get dayNames => {
    1: 'day_mon'.tr, 2: 'day_tue'.tr, 3: 'day_wed'.tr,
    4: 'day_thu'.tr, 5: 'day_fri'.tr, 6: 'day_sat'.tr, 7: 'day_sun'.tr,
  };

  static Map<String, String> get trainingTypes => {
    'bodybuilding': 'training_bodybuilding'.tr,
    'cardio':       'training_cardio'.tr,
    'crossfit':     'training_crossfit'.tr,
    'yoga':         'training_yoga'.tr,
    'mixed':        'training_mixed'.tr,
  };

  @override
  void onInit() {
    super.onInit();
    // تعيين تاريخ البداية لليوم
    final now = DateTime.now();
    startDate.value =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final typesRes   = await _client.get(ApiConstants.subscriptionTypes);
      final periodsRes = await _client.get(ApiConstants.memberAvailablePeriods);

      final types = typesRes['data'] as List;
      final p     = periodsRes['data'] as List;

      subscriptionTypes.assignAll(types);
      periods.assignAll(p);

      // اختر الأول تلقائياً
      if (types.isNotEmpty) selectedTypeId.value   = types.first['id'] as int;
      if (p.isNotEmpty)     selectedPeriodId.value  = p.first['id'] as int;
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (e) {
      error = 'failed_load_subscription_plans'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDay(int day) {
    if (trainingDays.contains(day)) {
      trainingDays.remove(day);
    } else {
      trainingDays.add(day);
    }
  }

  Future<void> subscribe() async {
    if (selectedTypeId.value == 0) {
      AppSnackbar.error('choose_subscription_type'.tr);
      return;
    }
    if (selectedPeriodId.value == 0) {
      AppSnackbar.error('choose_period'.tr);
      return;
    }
    if (trainingDays.isEmpty) {
      AppSnackbar.error('choose_training_days'.tr);
      return;
    }

    isSubscribing.value = true;
    try {
      await _client.post(
        ApiConstants.memberSubscriptions,
        data: {
          'subscription_type_id': selectedTypeId.value,
          'period_id':            selectedPeriodId.value,
          'training_type':        trainingType.value,
          'training_days':        trainingDays.toList(),
          'start_date':           startDate.value,
        },
      );

      AppSnackbar.success('subscription_created'.tr);

      // تحديث حالة الاشتراك في MainController
      await Get.find<MainController>().checkSubscription();

    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('error_try_again'.tr);
    } finally {
      isSubscribing.value = false;
    }
  }
}