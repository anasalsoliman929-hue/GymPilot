import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1600));

    final storage = Get.find<StorageService>();
    final token = storage.token;

    if (token == null || token.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // نتحقق من صلاحية التوكن ونجيب أحدث حالة للمدرب (خصوصاً is_temp_password)
    try {
      final auth = Get.find<AuthRepository>();
      final user = await auth.me();
      await storage.saveUser(user.toJson());

      if (user.isTempPassword) {
        Get.offAllNamed(AppRoutes.forceChangePassword);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (_) {
      // ApiClient بيتكفل بتسجيل الخروج التلقائي لو كان السبب 401
      await storage.clearSession();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
