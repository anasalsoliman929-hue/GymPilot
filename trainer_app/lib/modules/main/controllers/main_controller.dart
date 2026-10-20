import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';

class MainController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  RxInt currentIndex = 0.obs;

  UserModel? get currentUser {
    final json = _storage.user;
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  void changeTab(int index) => currentIndex.value = index;
}
