import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/trainer_repository.dart';
import '../../data/repositories/training_plan_repository.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../routes/app_routes.dart';
import '../network/api_client.dart';
import '../services/storage_service.dart';

/// يُسجَّل مرة واحدة عند إقلاع التطبيق (main.dart)
/// كل الكلاسات هون Singletons — موجودة طول عمر التطبيق
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);

    final apiClient = Get.put(ApiClient(), permanent: true);

    // التوكن انتهى أو غير صالح -> رجّعه لتسجيل الدخول من أي مكان
    apiClient.onUnauthorized = () => Get.offAllNamed(AppRoutes.login);

    // لسا عم يستخدم كلمة المرور المؤقتة -> اجبره يغيّرها قبل أي شي
    apiClient.onMustChangePassword = () {
      if (Get.currentRoute != AppRoutes.forceChangePassword) {
        Get.offAllNamed(AppRoutes.forceChangePassword);
      }
    };

    Get.put(AuthRepository(apiClient), permanent: true);
    Get.put(TrainerRepository(apiClient), permanent: true);
    Get.put(TrainingPlanRepository(apiClient), permanent: true);
    Get.put(NutritionRepository(apiClient), permanent: true);
    Get.put(NotificationsRepository(apiClient), permanent: true);
  }
}
