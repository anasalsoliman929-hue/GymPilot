import 'package:get/get.dart';
import '../../../data/models/gym_info_model.dart';
import '../../../data/repositories/public_repository.dart';

class WelcomeController extends GetxController {
  final PublicRepository _repo = Get.find<PublicRepository>();

  RxBool isLoading = true.obs;
  Rx<GymInfoModel?> gymInfo = Rx<GymInfoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadGymInfo();
  }

  Future<void> _loadGymInfo() async {
    isLoading.value = true;
    try {
      gymInfo.value = await _repo.getGymInfo();
    } catch (_) {
      // معلومات الصالة ثانوية — فشل جلبها ما لازم يمنع المستخدم من المتابعة لتسجيل الدخول
    } finally {
      isLoading.value = false;
    }
  }
}
