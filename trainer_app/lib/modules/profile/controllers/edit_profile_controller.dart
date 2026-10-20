import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/trainer_repository.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final TrainerRepository _repo = Get.find<TrainerRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final current = Get.find<ProfileController>().user.value;
    nameController.text = current?.name ?? '';
    phoneController.text = current?.phone ?? '';
  }

  String? validateName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'enter_name'.tr : null;

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      final updated = await _repo.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );
      await _storage.saveUser(updated.toJson());
      Get.find<ProfileController>().user.value = updated;
      Get.back();
      AppSnackbar.success('profile_updated_success'.tr);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('profile_update_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
