import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/progress_model.dart';
import '../../../data/repositories/progress_repository.dart';

class ProgressController extends GetxController {
  final ProgressRepository _repository = Get.find<ProgressRepository>();

  RxBool isLoading = true.obs;
  RxBool isSaving  = false.obs;
  RxString filter  = 'all'.obs;
  String? error;

  final RxList<ProgressEntryModel> records = <ProgressEntryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final history = await _repository.getHistory(filter: filter.value);
      records.assignAll(history.records);
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_progress'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String value) {
    filter.value = value;
    load();
  }

  Future<bool> addEntry(ProgressEntryModel entry) async {
    isSaving.value = true;
    try {
      await _repository.addEntry(entry);
      // AppSnackbar.success('measurement_saved'.tr);
      await load();
    
      return true;
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
      return false;
    } catch (_) {
      AppSnackbar.error('failed_save_measurement'.tr);
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
