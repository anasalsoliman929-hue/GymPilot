import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/training_plan_repository.dart';
import '../../../routes/app_routes.dart';

class TrainingPlanFormController extends GetxController {
  final TrainingPlanRepository _repo = Get.find<TrainingPlanRepository>();

  late final int memberId;
  final titleController = TextEditingController();
  final RxSet<int> selectedDays = <int>{}.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    memberId = Get.arguments as int;
  }

  void toggleDay(int day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      AppSnackbar.error('أدخل عنوان الخطة');
      return;
    }
    if (selectedDays.isEmpty) {
      AppSnackbar.error('اختر يوماً واحداً على الأقل');
      return;
    }
    isLoading.value = true;
    try {
      final plan = await _repo.createPlan(
        memberId: memberId,
        title: titleController.text.trim(),
        trainingDays: selectedDays.toList()..sort(),
      );
      AppSnackbar.success('تم إنشاء خطة التمرين');
      Get.offNamed(AppRoutes.trainingPlanDetails, arguments: plan.id);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر إنشاء الخطة');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
