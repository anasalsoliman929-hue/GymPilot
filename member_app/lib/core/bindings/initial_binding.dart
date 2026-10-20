import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/member_repository.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/repositories/complaint_repository.dart';
import '../../data/repositories/public_repository.dart';
import '../services/push_notification_service.dart';
import '../network/api_client.dart';
import '../services/storage_service.dart';
import '../../routes/app_routes.dart';

/// يُسجَّل مرة واحدة عند إقلاع التطبيق (main.dart)
/// كل الكلاسات هون Singletons — موجودة طول عمر التطبيق
///
/// ملاحظة: LanguageController و ThemeController يُسجَّلان في main.dart
/// مباشرة (قبل GetMaterialApp) لأن قيمهما الابتدائية (theme/locale)
/// تُقرأ عند بناء GetMaterialApp نفسه.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);

    final apiClient = Get.put(ApiClient(), permanent: true);
    
    apiClient.onUnauthorized = () => Get.offAllNamed(AppRoutes.login);
    Get.put(ApiClient(), permanent: true);
    Get.put(AuthRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(WorkoutRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(NutritionRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(ProgressRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(MemberRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(ComplaintRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(PublicRepository(Get.find<ApiClient>()), permanent: true);

    Get.put(PushNotificationService(), permanent: true).init();
  }
}
