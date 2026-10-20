import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/member_model.dart';
import '../../../data/repositories/trainer_repository.dart';

class HomeController extends GetxController {
  final TrainerRepository _repo = Get.find<TrainerRepository>();

  RxBool isLoading = true.obs;
  String? error;

  Rx<UserModel?> profile = Rx<UserModel?>(null);
  RxList<MemberModel> members = <MemberModel>[].obs;

  int get activeSubscriptionsCount =>
      members.where((m) => m.activeSubscription?.status == 'active').length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final results = await Future.wait([
        _repo.getProfile(),
        _repo.getMembers(),
      ]);
      profile.value = results[0] as UserModel;
      members.assignAll(results[1] as List<MemberModel>);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'تعذّر تحميل بيانات الرئيسية';
    } finally {
      isLoading.value = false;
    }
  }
}
