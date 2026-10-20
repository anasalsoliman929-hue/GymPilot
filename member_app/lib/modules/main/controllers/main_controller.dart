import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/member_repository.dart';

class MainController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final MemberRepository _memberRepo = Get.find<MemberRepository>();

  RxInt currentIndex = 0.obs;
  RxBool hasActiveSubscription = false.obs;
  RxBool isLoading = true.obs;

  UserModel? get currentUser {
    final json = _storage.user;
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  @override
  void onInit() {
    super.onInit();
    checkSubscription();
  }

  Future<void> checkSubscription() async {
    isLoading.value = true;
    try {
      final sub = await _memberRepo.getActiveSubscription();
      hasActiveSubscription.value = sub != null;
    } catch (_) {
      hasActiveSubscription.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}