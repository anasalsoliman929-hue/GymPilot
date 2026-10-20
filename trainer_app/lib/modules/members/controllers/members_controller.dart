import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/member_model.dart';
import '../../../data/repositories/trainer_repository.dart';

class MembersController extends GetxController {
  final TrainerRepository _repo = Get.find<TrainerRepository>();

  RxBool isLoading = true.obs;
  String? error;
  RxList<MemberModel> members = <MemberModel>[].obs;

  final searchController = RxString('');

  List<MemberModel> get filtered {
    final q = searchController.value.trim();
    if (q.isEmpty) return members;
    return members.where((m) => m.name.contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final res = await _repo.getMembers();
      members.assignAll(res);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'تعذّر تحميل قائمة الأعضاء';
    } finally {
      isLoading.value = false;
    }
  }
}
