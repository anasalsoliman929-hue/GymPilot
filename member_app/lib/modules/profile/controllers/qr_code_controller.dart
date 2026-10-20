import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/member_repository.dart';

class QrCodeController extends GetxController {
  final MemberRepository _repository = Get.find<MemberRepository>();

  RxBool isLoading = true.obs;
  final RxString qrToken = ''.obs;
  String? error;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      qrToken.value = await _repository.getQrToken();
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_qr'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
