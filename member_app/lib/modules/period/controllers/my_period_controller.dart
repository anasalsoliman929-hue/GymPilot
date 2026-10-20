import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/training_period_model.dart';
import '../../../data/repositories/member_repository.dart';

class MyPeriodController extends GetxController {
  final MemberRepository _repo = Get.find<MemberRepository>();

  RxBool isLoading = true.obs;
  Rx<TrainingPeriodModel?> period = Rx<TrainingPeriodModel?>(null);
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
      period.value = await _repo.getMyPeriod();
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_period'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
