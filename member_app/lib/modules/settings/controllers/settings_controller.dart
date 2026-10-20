import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/gym_info_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/public_repository.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final PublicRepository _publicRepository = Get.find<PublicRepository>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<GymInfoModel?> gymInfo = Rx<GymInfoModel?>(null);
  var notifications = true.obs;
  var isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    final json = _storage.user;
    if (json != null) user.value = UserModel.fromJson(json);
    _loadGymInfo();
  }

  Future<void> _loadGymInfo() async {
    try {
      gymInfo.value = await _publicRepository.getGymInfo();
    } catch (_) {
      // معلومات الصالة ثانوية — فشل جلبها ما لازم يوقف باقي الصفحة
    }
  }

  void toggleNotifications(bool value) {
    notifications.value = value;
    // ملاحظة: لا يوجد حالياً تسجيل فعلي لتفضيل الإشعارات على السيرفر
    // (تكامل FCM يحتاج مفتاح Firebase حقيقي من صاحب التطبيق)
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
    } catch (_) {
      // نسجّل الخروج محلياً بكل الحالات
    } finally {
      await _storage.clearSession();
      isLoggingOut.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
