import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/complaint_model.dart';
import '../../../data/repositories/complaint_repository.dart';

class ComplaintsController extends GetxController {
  final ComplaintRepository _repo = Get.find<ComplaintRepository>();

  RxBool isLoading = true.obs;
  RxBool isSending = false.obs;
  String? error;

  final RxList<ComplaintModel> complaints = <ComplaintModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final list = await _repo.getComplaints();
      // الأحدث أولاً
      list.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      complaints.assignAll(list);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_complaints'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submit({required String subject, required String message}) async {
    isSending.value = true;
    try {
      final created = await _repo.submitComplaint(subject: subject, message: message);
      complaints.insert(0, created);
      AppSnackbar.success('complaint_submitted_success'.tr);
      return true;
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
      return false;
    } catch (_) {
      AppSnackbar.error('failed_submit_complaint'.tr);
      return false;
    } finally {
      isSending.value = false;
    }
  }
}
