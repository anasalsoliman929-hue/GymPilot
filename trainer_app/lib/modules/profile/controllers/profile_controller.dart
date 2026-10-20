import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/trainer_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final TrainerRepository _trainerRepo = Get.find<TrainerRepository>();
  final StorageService _storage = Get.find<StorageService>();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    refresh();
  }

  void _loadFromCache() {
    final json = _storage.user;
    if (json != null) user.value = UserModel.fromJson(json);
  }

  Future<void> refresh() async {
    isLoading.value = true;
    try {
      final fresh = await _trainerRepo.getProfile();
      user.value = fresh;
      await _storage.saveUser(fresh.toJson());
    } catch (_) {
      // إذا فشل التحديث نكتفي بالنسخة المخزّنة محلياً
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepo.logout();
    } catch (_) {
      // تجاهل فشل الطلب — بننضف الجلسة محلياً بأي الحالتين
    }
    await _storage.clearSession();
    Get.offAllNamed(AppRoutes.login);
  }
}
