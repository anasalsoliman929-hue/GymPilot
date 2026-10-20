import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/models/legal_document_model.dart';
import '../../../data/repositories/public_repository.dart';

class LegalDocumentController extends GetxController {
  final PublicRepository _repo = Get.find<PublicRepository>();

  final String documentKey;
  LegalDocumentController(this.documentKey);

  RxBool isLoading = true.obs;
  Rx<LegalDocumentModel?> document = Rx<LegalDocumentModel?>(null);
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
      document.value = await _repo.getLegalDocument(documentKey);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_document'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
