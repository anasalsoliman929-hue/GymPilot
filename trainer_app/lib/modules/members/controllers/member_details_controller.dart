import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/member_model.dart';
import '../../../data/repositories/trainer_repository.dart';

class MemberDetailsController extends GetxController {
  final TrainerRepository _repo = Get.find<TrainerRepository>();

  late final int memberId;
  RxBool isLoading = true.obs;
  String? error;
  Rx<MemberModel?> member = Rx<MemberModel?>(null);

  @override
  void onInit() {
    super.onInit();
    memberId = Get.arguments as int;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      member.value = await _repo.getMemberDetails(memberId);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'تعذّر تحميل بيانات العضو';
    } finally {
      isLoading.value = false;
    }
  }
}
